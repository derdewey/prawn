<<<<<<< HEAD
# encoding: utf-8

# prawn.rb : A library for PDF generation in Ruby
#
# Copyright April 2008, Gregory Brown.  All Rights Reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.
           
require "prawn/compatibility"
require "prawn/errors"
require "prawn/pdf_object"
=======
# Welcome to Prawn, the best PDF Generation library ever.
# This documentation covers user level functionality.
#
# Those looking to contribute code or write extensions should look
# into the lib/prawn/core/* source tree.
#
module Prawn #:nodoc:
  VERSION = "0.11.1.pre"
end

require "prawn/core"
require "prawn/text"
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
require "prawn/graphics"
require "prawn/images"
require "prawn/images/jpg"
require "prawn/images/png"
<<<<<<< HEAD
require "prawn/document"
require "prawn/reference"
require "prawn/font" 

%w[font_ttf].each do |dep|
  $LOAD_PATH.unshift(File.dirname(__FILE__) + "/../vendor/#{dep}")
end

require 'ttf'

module Prawn 
  file = __FILE__
  file = File.readlink(file) if File.symlink?(file)
  dir = File.dirname(file)
                          
  # The base source directory for Prawn as installed on the system
  BASEDIR = File.expand_path(File.join(dir, '..'))    
end
=======
require "prawn/stamp"
require "prawn/security"
require "prawn/document"
require "prawn/font"
require "prawn/encoding"
require "prawn/measurements"
require "prawn/repeater"
require "prawn/outline"
require "prawn/layout"

>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
