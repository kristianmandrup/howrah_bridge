require 'prawn'  
require 'activesupport/inflector'
require 'howrah/prawn/document_builder'
require 'howrah/nokogiri/decorator'

module Howrah
  class Bridge
    attr_accessor :options, :file_name
    
    def default_options
      {:dry_run => true} 
    end    
    
    def initialize(options = {})      
      raise ArgumentError, "Supplied options must be of type Hash" if !options.kind_of? Hash
      @options    = options    
      @file_name  = options[:file_name]  
    end
    
    # let the html handler handle the html element and take it from there
    def cross(html_doc, options = {}, &block)
      options = {:to => :pdf, :via => :prawn}.merge(options)      
      html_root_element.process(html_doc, options, &block)
      render_pdf if render_pdf?
    end

    protected

    def render_pdf?
      !options[:dry_run] && file_name      
    end
    
    def html_root_element
      html_document(html_doc).css('html').first      
    end

    def render_pdf
      prawn_document.render_file file_name 
    end      

    def self.prawn_document
      Howrah::Prawn::DocumentBuilder.build options[:prawn_document]
    end

    def self.html_document(html_doc)
      case html
      when String
        # create Nokogiri document
        html_doc = Nokogiri::HTML.parse(html)
      when Nokogiri::Document
        # nothing
      else
        raise ArgumentError, "Must be HTML string or Nokogiri Document"
      end
      Howrah::Nokogiri::Decorator.decorate! html_doc
    end
  end
end
