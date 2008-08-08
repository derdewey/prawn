# encoding: utf-8

# text.rb : Implements PDF text primitives
#
# Copyright May 2008, Gregory Brown. All Rights Reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.
require "zlib"

module Prawn
  class Document  
    module Text
      DEFAULT_FONT_SIZE = 12
      
      # The built in fonts specified by the Adobe PDF spec.
      BUILT_INS = %w[ Courier Courier-Bold Courier-Oblique Courier-BoldOblique
                      Helvetica Helvetica-Bold Helvetica-Oblique
                      Helvetica-BoldOblique Times-Roman Times-Bold Times-Italic
                      Times-BoldItalic Symbol ZapfDingbats ]

      # Draws text on the page. If a point is specified via the <tt>:at</tt>
      # option the text will begin exactly at that point, and the string is
      # assumed to be pre-formatted to properly fit the page.
      #
      # When <tt>:at</tt> is not specified, Prawn attempts to wrap the text to
      # fit within your current bounding box (or margin box if no bounding box
      # is being used ). Text will flow onto the next page when it reaches
      # the bottom of the margin_box. Text wrap in Prawn does not re-flow
      # linebreaks, so if you want fully automated text wrapping, be sure to
      # remove newlines before attempting to draw your string.
      #
      #   pdf.text "Hello World", :at => [100,100]
      #   pdf.text "Goodbye World", :at => [50,50], :size => 16
      #   pdf.text "Will be wrapped when it hits the edge of your bounding box"
      #
      # All strings passed to this function should be encoded as UTF-8.
      # If you get unexpected characters appearing in your rendered 
      # document, check this.
      #
      # If an empty box is rendered to your PDF instead of the character you 
      # wanted it usually means the current font doesn't include that character.
      #
      def text(text,options={})
        # check the string is encoded sanely
        normalize_encoding(text)

        if options.key?(:kerning)
          options[:kerning] = false unless font_metrics.has_kerning_data?
        else
          options[:kerning] = true if font_metrics.has_kerning_data?
        end

        # ensure a valid font is selected
        font "Helvetica" unless fonts[@font]

        return wrapped_text(text,options) unless options[:at]
        
        x,y = translate(options[:at])
        font_size(options[:size] || current_font_size) do
          add_text_content(text,x,y,options)
        end  
      end

      def font_metrics #:nodoc:
        @font_metrics ||= Prawn::Font::Metrics["Helvetica"]
      end

      # Sets the current font.
      #
      # The single parameter must be a string. It can be one of the 14 built-in
      # fonts supported by PDF, or the location of a TTF file. The BUILT_INS
      # array specifies the valid built in font values.
      #
      #   pdf.font "Times-Roman"
      #   pdf.font "Chalkboard.ttf"
      #
      # If a ttf font is specified, the full file will be embedded in the 
      # rendered PDF. This should be your preferred option in most cases. 
      # It will increase the size of the resulting file, but also make it 
      # more portable.
      #
      def font(name)
        proc_set :PDF, :Text
        @font_metrics = Prawn::Font::Metrics[name]
        case(name)
        when /\.ttf$/
          @font = embed_ttf_font(name)
        else
          @font = register_builtin_font(name)
        end
        set_current_font
      end
      
      # Sets the default font size for use within a block.  Individual overrides
      # can be used as desired.  The previous font size will be restored after the
      # block.
      #
      #  Prawn::Document.generate("font_size.pdf") do
      #   font_size!(16) 
      #   text "At size 16"
      #
      #   font_size(10) do
      #     text "At size 10"
      #     text "At size 6", :size => 6
      #     text "At size 10"
      #   end
      #
      #   text "At size 16"
      #  end
      #
      def font_size(size=nil)
        return current_font_size unless size
        font_size_before_block = @font_size || DEFAULT_FONT_SIZE
        font_size!(size)
        yield
        font_size!(font_size_before_block)
      end
      
      # Sets the default font size. See example in font_size
      #
      def font_size!(size)
        @font_size = size unless size == nil
      end   
      
      alias_method :font_size=, :font_size!

      private  
      


       def render_inline_text_segments(text,options={}) 
          if options[:at]
            x, y = options[:at]
          else
            x = horizontal_cursor(options[:align])
            y = self.y 
          end

          StyleParser.process(text).each do |segment| 
            if StyleParser.style_tag?(segment)
              adjust_font_style(segment)
            else                      
              segment.gsub!("&lt;","<")    
              segment.gsub!("&gt;",">")
              add_text_content(segment,x,y,options)      
              x += text_width(segment, font_size) 
            end
          end              
       end

       def adjust_font_style(modifier="")
         require "set"
         @font_style ||= Set.new             
         case(modifier)
         when "<i>"
           @font_style << "i"
         when "<b>"
           @font_style << "b"
         when "</i>"
           @font_style.delete "i"
         when "</b>"
           @font_style.delete "b"
         end                      
         n = font_families[@font.match(/(\w+)-?/)[1]][@font_style.to_a.join] 
         font(n) if n && @font != n
       end        

       def font_families
         @font_families ||= Hash.new { |h,k| h[k] = {} }.update(
           "Helvetica" => {
             "b"   => 'Helvetica-Bold',
             "i"   => 'Helvetica-Oblique',
             "bi"  => 'Helvetica-BoldOblique',
             "ib"  => 'Helvetica-BoldOblique',
             ""    => 'Helvetica'
           },
           "Courier" => {
             "b"   => 'Courier-Bold',
             "i"   => 'Courier-Oblique',
             "bi"  => 'Courier-BoldOblique',
             "ib"  => 'Courier-BoldOblique',
             ""    => 'Courier'
           },
           'Times' => {
             "b"   => 'Times-Bold',
             "i"   => 'Times-Italic',
             "bi"  => 'Times-BoldItalic',
             "ib"  => 'Times-BoldItalic',
             ""    => 'Times-Roman'
           })
      end
      
      # The current font_size being used in the document.
      #
      def current_font_size
        @font_size || DEFAULT_FONT_SIZE
      end

      def move_text_position(dy)
         (y - dy) < @margin_box.absolute_bottom ? start_new_page : self.y -= dy       
      end

      def text_width(text,size)
        @font_metrics.string_width(text,size)
      end                                         
      
      def horizontal_cursor(align)
        case(align) 
        when :left
          x = @bounding_box.absolute_left
        when :center
          x = @bounding_box.absolute_left + 
            (@bounding_box.width - line_width) / 2.0
        when :right
          x = @bounding_box.absolute_right - line_width
        end        
      end

      def wrapped_text(text,options) 
        options[:align] ||= :left
        font_size(options[:size] || current_font_size) do

          text = @font_metrics.naive_wrap(text, bounds.right, current_font_size, 
            :kerning => options[:kerning]) 

          lines = text.lines

          lines.each do |e|              
            move_text_position(@font_metrics.font_height(current_font_size) +
                           @font_metrics.descender / 1000.0 * current_font_size)  
                               
                           
            #line_width = text_width(e,font_size) 
            if StyleParser.style_tag?(e)
              render_inline_text_segments(e,options)
            else
              x = horizontal_cursor(options[:align])
                               
              add_text_content(e,x,y,options)             
            end
            
            ds = -@font_metrics.descender / 1000.0 * current_font_size 
            move_text_position(options[:spacing] || ds )        
          end
        end
      end  
      
      def add_text_content(text, x, y, options)          
        text      = @font_metrics.convert_text(text,options)    
        font_name = font_registry[fonts[@font]] 
           
        add_content %Q{
          BT
          /#{font_name} #{font_size} Tf
          #{x} #{y} Td
        }
      
        add_content Prawn::PdfObject(text, true) <<
          " #{options[:kerning] ? 'TJ' : 'Tj'}\n"
      
        add_content %Q{
          ET
        }
      end  

      def embed_ttf_font(file) #:nodoc:

        ttf_metrics = Prawn::Font::Metrics::TTF.new(file)

        unless File.file?(file)
          raise ArgumentError, "file #{file} does not exist"
        end

        basename = @font_metrics.basename

        raise "Can't detect a postscript name for #{file}" if basename.nil?

        enctables[basename] = @font_metrics.enc_table

        if enctables[basename].nil?
          raise "#{file} missing the required encoding table" 
        end

        font_content    = File.open(file,"rb") { |f| f.read }
        compressed_font = Zlib::Deflate.deflate(font_content)

        fontfile = ref(:Length  => compressed_font.size,
                       :Length1 => font_content.size,
                       :Filter => :FlateDecode )
        fontfile << compressed_font

        # TODO: Not sure what to do about CapHeight, as ttf2afm doesn't
        #       pick it up. Missing proper StemV and flags
        #
        descriptor = ref(:Type        => :FontDescriptor,
                         :FontName    => basename,
                         :FontFile2   => fontfile,
                         :FontBBox    => @font_metrics.bbox,
                         :Flags       => 32, # FIXME: additional flags
                         :StemV       => 0,
                         :ItalicAngle => 0,
                         :Ascent      => @font_metrics.ascender,
                         :Descent     => @font_metrics.descender
                         )

        descendant = ref(:Type           => :Font,
                         :Subtype        => :CIDFontType2, # CID, TTF
                         :BaseFont       => basename,
                         :CIDSystemInfo  => { :Registry   => "Adobe", 
                                              :Ordering   => "Identity", 
                                              :Supplement => 0 },
                         :FontDescriptor => descriptor,
                         :W              => @font_metrics.glyph_widths,
                         :CIDToGIDMap    => :Identity
                        )

        to_unicode_content = @font_metrics.to_unicode_cmap.to_s
        compressed_to_unicode = Zlib::Deflate.deflate(to_unicode_content)
        to_unicode = ref(:Length  => compressed_to_unicode.size,
                         :Length1 => to_unicode_content.size,
                         :Filter => :FlateDecode )
        to_unicode << compressed_to_unicode

        # TODO: Needs ToUnicode (at least)
        fonts[basename] ||= ref(:Type            => :Font,
                                :Subtype         => :Type0,
                                :BaseFont        => basename,
                                :DescendantFonts => [descendant],
                                :Encoding        => :"Identity-H",
                                :ToUnicode       => to_unicode)
        return basename
      end

      def normalize_encoding(text)
        # TODO: if the current font is a built in one, we can't use the utf-8
        # string provided by the user. We should convert it to WinAnsi or
        # MacRoman or some such.
        if text.respond_to?(:"encode!")
          # if we're running under a M17n aware VM, ensure the string provided is
          # UTF-8 (by converting it if necessary)
          begin
            text.encode!("UTF-8")
          rescue
            raise Prawn::Errors::IncompatibleStringEncoding, "Encoding " +
            "#{text.encoding} can not be transparently converted to UTF-8. " +
            "Please ensure the encoding of the string you are attempting " +
            "to use is set correctly"
          end
        else
          # on a non M17N aware VM, use unpack as a hackish way to verify the
          # string is valid utf-8. I thought it was better than loading iconv
          # though.
          begin
            text.unpack("U*")
          rescue
            raise Prawn::Errors::IncompatibleStringEncoding, "The string you " +
            "are attempting to render is not encoded in valid UTF-8."
          end
        end
      end

      def register_builtin_font(name) #:nodoc:
        unless BUILT_INS.include?(name)
          raise Prawn::Errors::UnknownFont, "#{name} is not a known font."
        end
        fonts[name] ||= ref(:Type => :Font,
                            :Subtype => :Type1,
                            :BaseFont => name.to_sym,
                            :Encoding => :MacRomanEncoding)
        return name
      end

      def set_current_font #:nodoc:
        return if @font.nil?
        font_registry[fonts[@font]] ||= :"F#{font_registry.size + 1}"

        page_fonts.merge!(
          font_registry[fonts[@font]] => fonts[@font]
        )
      end

      def enctables #:nodoc
        @enctables ||= {}
      end 
      
      def font_registry #:nodoc:
        @font_registry ||= {}
      end

      def fonts #:nodoc:
        @fonts ||= {}
      end 
      
      module StyleParser  
        
        module_function 
        
        TAG_PATTERN = %r{(</?[ib]>)}
        
        def process(text) #:nodoc:  
          segments = text.split(TAG_PATTERN).delete_if{|x| x.empty? }
          segments    
        end    

        def style_tag?(text)
          !!(text =~ TAG_PATTERN)
        end 
        
      end

    end
  end
end
