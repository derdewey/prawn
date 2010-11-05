# encoding: utf-8
<<<<<<< HEAD

=======
#
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
# errors.rb : Implements custom error classes for Prawn
#
# Copyright April 2008, Gregory Brown.  All Rights Reserved.
#
# This is free software. Please see the LICENSE and COPYING files for details.
<<<<<<< HEAD

=======
#
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
module Prawn
  module Errors
     
     # This error is raised when Prawn::PdfObject() encounters a Ruby object it
     # cannot convert to PDF
     #
<<<<<<< HEAD
     class FailedObjectConversion < StandardError; end
=======
     FailedObjectConversion = Class.new(StandardError)
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
     
     # This error is raised when Document#page_layout is set to anything
     # other than :portrait or :landscape            
     #
<<<<<<< HEAD
     class InvalidPageLayout < StandardError; end        
     
     # This error is raised when Prawn cannot find a specified font   
     #
     class UnknownFont < StandardError; end   

     # This error is raised when prawn is being used on a M17N aware VM,
     # and the user attempts to add text that isn't compatible with UTF-8
     # to their document
     #
     class IncompatibleStringEncoding < StandardError; end   
     
=======
     InvalidPageLayout = Class.new(StandardError)       
     
     # This error is raised when a method requiring a current page is called 
     # without being on a page.
     #
     NotOnPage = Class.new(StandardError)
     
     # This error is raised when Prawn cannot find a specified font   
     #
     UnknownFont = Class.new(StandardError)   

     # Raised when Prawn is asked to draw something into a too-small box
     #
     CannotFit = Class.new(StandardError)

     # Raised if group() is called with a block that is too big to be
     # rendered in the current context.
     #
     CannotGroup = Class.new(StandardError) 

     # This error is raised when Prawn is being used on a M17N aware VM,
     # and the user attempts to add text that isn't compatible with UTF-8
     # to their document
     #
     IncompatibleStringEncoding = Class.new(StandardError)
     
     # This error is raised when Prawn encounters an unknown key in functions
     # that accept an options hash.  This usually means there is a typo in your
     # code or that the option you are trying to use has a different name than
     # what you have specified. 
     #
     UnknownOption = Class.new(StandardError)

     # this error is raised when a user attempts to embed an image of an unsupported
     # type. This can either a completely unsupported format, or a dialect of a
     # supported format (ie. some types of PNG)
     UnsupportedImageType = Class.new(StandardError)

    # This error is raised when a named element has alredy been
    # created. For example, in the stamp module, stamps must have
    # unique names within a document
    NameTaken = Class.new(StandardError)

    # This error is raised when a name is not a valid format
    InvalidName = Class.new(StandardError)

    # This error is raised when an object is attempted to be
    # referenced by name, but no such name is associated with an object
    UndefinedObjectName = Class.new(StandardError)
    
    # This error is raised when a required option has not been set
    RequiredOption = Class.new(StandardError)
    
    # This error is raised when a requested outline item with a given title does not exist
    UnknownOutlineTitle = Class.new(StandardError)

    # This error is raised when a block is required, but not provided
    BlockRequired = Class.new(StandardError)
    
    # This error is rased when a graphics method is called with improper arguments
    InvalidGraphicsPath = Class.new(StandardError)
    
    # This error is raised when Prawn fails to load a template file
    #
    TemplateError = Class.new(StandardError)
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
  end
end   
