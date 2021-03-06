# encoding: utf-8

require File.join(File.expand_path(File.dirname(__FILE__)), "spec_helper")  
<<<<<<< HEAD

class ImageObserver

  attr_accessor :page_xobjects

  def initialize
    @page_xobjects = []
  end

  def resource_xobject(*params)
    @page_xobjects.last << params.first
  end

  def begin_page(*params)
    @page_xobjects << [] 
  end
end

describe "the image() function" do

  before(:each) do
    @filename = "#{Prawn::BASEDIR}/data/images/pigs.jpg"
    create_pdf
  end

  it "should only embed an image once, even if it's added multiple times" do
    @pdf.image @filename, :at => [100,100]
    @pdf.image @filename, :at => [300,300]

    images = observer(ImageObserver)

    # there should be 2 images in the page resources
    images.page_xobjects.first.size.should == 2

    # but only 1 image xobject
    @output.scan(/\/Type \/XObject/).size.should == 1
  end  
=======
require 'set'

describe "the image() function" do

  before(:each) do
    @filename = "#{Prawn::BASEDIR}/data/images/pigs.jpg" 
    create_pdf
  end

  it "should only embed an image once, even if it's added multiple times" do
    @pdf.image @filename, :at => [100,100]
    @pdf.image @filename, :at => [300,300]
           
    output = @pdf.render
    images = PDF::Inspector::XObject.analyze(output)
    # there should be 2 images in the page resources
    images.page_xobjects.first.size.should == 2
    # but only 1 image xobject
    output.scan(/\/Type \/XObject/).size.should == 1
  end  
  
  it "should return the image info object" do
    info =  @pdf.image(@filename)
    
    info.should.be.kind_of(Prawn::Images::JPG)
    
    info.height.should == 453
  end
  
  it "should accept IO objects" do
    file = File.open(@filename, "rb")
    info = @pdf.image(file)
    
    info.height.should == 453
  end

  it "should raise an UnsupportedImageType if passed a BMP" do
    filename = "#{Prawn::BASEDIR}/data/images/tru256.bmp"
    lambda { @pdf.image filename, :at => [100,100] }.should.raise(Prawn::Errors::UnsupportedImageType)
  end

  it "should raise an UnsupportedImageType if passed an interlaced PNG" do
    filename = "#{Prawn::BASEDIR}/data/images/dice_interlaced.png"
    lambda { @pdf.image filename, :at => [100,100] }.should.raise(Prawn::Errors::UnsupportedImageType)
  end

  it "should bump PDF version to 1.5 or greater on embedding 16-bit PNGs" do
    @pdf.image "#{Prawn::BASEDIR}/data/images/16bit.png"
    @pdf.state.version.should >= 1.5
  end

  # to support Adobe Reader, which apparently doesn't handle 16-bit alpha
  # channels. Verified experimentally [BE] but not confirmed in documentation
  # or anything. OS X Preview handles those files just fine.
  #
  it "should embed 8-bit alpha channels for 16-bit PNGs" do
    @pdf.image "#{Prawn::BASEDIR}/data/images/16bit.png"

    output = @pdf.render
    output.should =~ /\/BitsPerComponent 16/
    output.should =~ /\/BitsPerComponent 8/
  end
  
  it "should flow an image to a new page if it will not fit on a page" do
    @pdf.image @filename, :fit => [600, 600]
    @pdf.image @filename, :fit => [600, 600]
    output = StringIO.new(@pdf.render, 'r+')
    hash = PDF::Hash.new(output)
    pages = hash.values.find {|obj| obj.is_a?(Hash) && obj[:Type] == :Pages}[:Kids]
    pages.size.should == 2 
    hash[pages[0]][:Resources][:XObject].keys.should == [:I1]
    hash[pages[1]][:Resources][:XObject].keys.should == [:I2]
  end 
  
  it "should not flow an image to a new page if it will fit on one page" do
    @pdf.image @filename, :fit => [400, 400]
    @pdf.image @filename, :fit => [400, 400]
    output = StringIO.new(@pdf.render, 'r+')
    hash = PDF::Hash.new(output)
    pages = hash.values.find {|obj| obj.is_a?(Hash) && obj[:Type] == :Pages}[:Kids]
    pages.size.should == 1 
    Set.new(hash[pages[0]][:Resources][:XObject].keys).should ==
      Set.new([:I1, :I2])
  end
  
  describe ":fit option" do
    it "should fit inside the defined constraints" do
      info = @pdf.image @filename, :fit => [100,400]
      info.scaled_width.should <= 100
      info.scaled_height.should <= 400

      info = @pdf.image @filename, :fit => [400,100]
      info.scaled_width.should <= 400
      info.scaled_height.should <= 100

      info = @pdf.image @filename, :fit => [604,453]
      info.scaled_width.should == 604
      info.scaled_height.should == 453
    end
    it "should move text position" do
      @y = @pdf.y
      info = @pdf.image @filename, :fit => [100,400]
      @pdf.y.should < @y
    end
  end

  describe ":at option" do
    it "should not move text position" do
      @y = @pdf.y
      info = @pdf.image @filename, :at => [100,400]
      @pdf.y.should == @y
    end
  end

>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
end

