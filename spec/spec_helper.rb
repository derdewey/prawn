# encoding: utf-8

puts "Prawn specs: Running on Ruby Version: #{RUBY_VERSION}"

require "rubygems"
<<<<<<< HEAD
require "test/spec"                                                
require "mocha"
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib') 
require "prawn"
gem 'pdf-reader', ">=0.7.3"
require "pdf/reader"

module Prawn
  class Document
    public :ref
  end
end

def create_pdf
  @pdf = Prawn::Document.new(:left_margin   => 0,
                             :right_margin  => 0,
                             :top_margin    => 0,
                             :bottom_margin => 0)
end    

def observer(klass)                                     
  @output = @pdf.render
  obs = klass.new
  PDF::Reader.string(@output,obs)
  obs   
end     

def parse_pdf_object(obj)
  PDF::Reader::Parser.new(
     PDF::Reader::Buffer.new(sio = StringIO.new(obj)), nil).parse_token   
end    

def rb_flag
  ruby_18 { "rb" } || ruby_19 { "rb:ASCII-8BIT" }
=======
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'lib') 
$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', 'vendor',
                             'pdf-inspector','lib')
require "prawn"

Prawn.debug = true

ruby_19 do
  gem "test-unit", "=1.2.3"
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
end
require "test/spec"
require "mocha"

gem 'pdf-reader', ">=0.8"
require "pdf/reader"          
require "pdf/inspector"

def create_pdf(klass=Prawn::Document)
  @pdf = klass.new(:margin => 0)
end    

# Make some methods public to assist in testing
module Prawn::Graphics
  public :map_to_absolute
end

require File.expand_path(File.join(File.dirname(__FILE__),
                                   %w[extensions mocha]))

