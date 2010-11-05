<<<<<<< HEAD
# encoding: utf-8

if RUBY_VERSION < "1.9"
  require "strscan"
  
  class String
    alias_method :lines, :to_a
    
    def each_char
      scanner, char = StringScanner.new(self), /./mu
      loop { yield(scanner.scan(char) || break) }
    end
  end 
  
  def ruby_18
    yield
  end
  
  def ruby_19
=======
# coding: utf-8
#
# Why would we ever use Ruby 1.8.7 when we can backport with something
# as simple as this?
#
class String  #:nodoc:
  def first_line
    self.each_line { |line| return line }
  end
  unless "".respond_to?(:lines)
    alias_method :lines, :to_a
  end
  unless "".respond_to?(:each_char)
    def each_char #:nodoc:
      # copied from jcode
      if block_given?
        scan(/./m) { |x| yield x }
      else
        scan(/./m)
      end
    end
  end
end

unless File.respond_to?(:binread) 
  def File.binread(file) #:nodoc:
    File.open(file,"rb") { |f| f.read } 
  end
end

if RUBY_VERSION < "1.9"
  
  def ruby_18  #:nodoc:  
    yield
  end
  
  def ruby_19  #:nodoc:  
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
    false
  end
     
else  
 
<<<<<<< HEAD
  def ruby_18 
    false  
  end
  
  def ruby_19
=======
  def ruby_18  #:nodoc:  
    false  
  end
  
  def ruby_19  #:nodoc:  
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
    yield
  end 
  
end 
