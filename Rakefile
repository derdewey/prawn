require 'rubygems'
require 'rake'
require 'rake/testtask'
require "rake/rdoctask"
require "rake/gempackagetask"  

<<<<<<< HEAD
PRAWN_VERSION = "0.1.99" 

task :default => [:test]
       
desc "Run all tests, test-spec and mocha required"
Rake::TestTask.new do |test|
  test.libs << "spec"
  test.test_files = Dir[ "spec/*_spec.rb" ]
  test.verbose = true
=======
task :default => [:test]
       
desc "Run all tests, test-spec, mocha, and pdf-reader required"
Rake::TestTask.new do |test|
  # test.ruby_opts  << "-w"  # .should == true triggers a lot of warnings
  test.libs       << "spec"
  test.test_files =  Dir[ "spec/*_spec.rb" ]
  test.verbose    =  true
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
end

desc "Show library's code statistics"
task :stats do
	require 'code_statistics'
<<<<<<< HEAD
=======
  CodeStatistics::TEST_TYPES << "Specs"	
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
	CodeStatistics.new( ["Prawn", "lib"], 
	                    ["Specs", "spec"] ).to_s
end

desc "genrates documentation"
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_files.include( "README",
                           "COPYING",
<<<<<<< HEAD
                           "LICENSE", "lib/" )
=======
                           "LICENSE", 
                           "HACKING", "lib/" )
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
  rdoc.main     = "README"
  rdoc.rdoc_dir = "doc/html"
  rdoc.title    = "Prawn Documentation"
end     

desc "run all examples, and then diff them against reference PDFs"
task :examples do 
  mkdir_p "output"
<<<<<<< HEAD
  examples = Dir["examples/*.rb"].reject { |e| e =~ /bench/ }   
  t = Time.now
  puts "Running Examples, skipping benchmark"
  examples.each { |file| `ruby -Ilib #{file}` }  
  puts "Ran in #{Time.now - t} s"        
  `mv *.pdf output`                     
                   
  unless RUBY_VERSION < "1.9"    
    puts "Checking for differences..."
    output = Dir["output/*.pdf"]
    ref    = Dir["reference_pdfs/*.pdf"]   
    output.zip(ref).each do |o,r|
      system "diff -q #{o} #{r}"
    end                      
  end

end

spec = Gem::Specification.new do |spec|
  spec.name = "prawn"
  spec.version = PRAWN_VERSION
  spec.platform = Gem::Platform::RUBY
  spec.summary = "A fast and nimble PDF generator for Ruby"
  spec.files =  Dir.glob("{examples,lib,spec,vendor,data}/**/**/*") +
                      ["Rakefile"]
  spec.require_path = "lib"
  
  spec.test_files = Dir[ "test/*_test.rb" ]
  spec.has_rdoc = true
  spec.extra_rdoc_files = %w{README LICENSE COPYING}
  spec.rdoc_options << '--title' << 'Prawn Documentation' <<
                       '--main'  << 'README' << '-q'
  spec.author = "Gregory Brown"
  spec.email = "  gregory.t.brown@gmail.com"
  spec.rubyforge_project = "prawn"
  spec.homepage = "http://prawn.majesticseacreature.com"
  spec.description = <<END_DESC
  Prawn is a fast, tiny, and nimble PDF generator for Ruby
END_DESC
end

=======
  examples = Dir["examples/**/*.rb"]
  t = Time.now
  puts "Running Examples"
  examples.each { |file| `ruby -Ilib #{file}` }  
  puts "Ran in #{Time.now - t} s"        
  `mv *.pdf output`                     
end

spec = Gem::Specification.load "prawn.gemspec"
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

<<<<<<< HEAD



=======
>>>>>>> cd81f1e61bc5acf842b52f9e1abbbd5795edb5db
