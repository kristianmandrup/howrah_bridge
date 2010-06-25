require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "howrah"
    gem.summary = %Q{Convert HTML and CSS to PDF using prawn}
    gem.description = %Q{Uses CSS parser, Nokogiri and latest Prawn 0.10+ to do the conversion}
    gem.email = "kmandrup@gmail.com"
    gem.homepage = "http://github.com/kristianmandrup/prawn-html"
    gem.authors = ["Kristian Mandrup", "Anuj"]
    gem.add_development_dependency "rspec", ">= 2.0.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.add_dependency "prawn", ">= 0.10.0"
    gem.add_dependency "nokogiri", ">= 1.4.1"
    # gem.add_dependency "pdf-reader"    
    gem.add_dependency "html_css_decorator", ">= 0.1.2"
    gem.add_dependency "activesupport", ">= 3.0.0.beta4"
    gem.add_dependency 'foxy_factory'
    # gem.add_dependency 'howrah_processor' # Add when it is available and works!

    # add more gem options here    
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

