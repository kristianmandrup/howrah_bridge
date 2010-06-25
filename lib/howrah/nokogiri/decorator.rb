# TODO: Check Processor and Renderer if this class is defined there!
module Howrah
  module Nokogiri
    module Decorator              
      def self.decorate! doc        
        doc = ::CSS::Model.apply_to(doc)
        [:element, :text, :node].each do |type|
          doc.decorators("Nokogiri::XML::#{type.camelize}".constantize) << "Howrah::Processor::XML::#{type.camelize}".constantize
        end
        doc.decorate!
        doc
      end
    end
  end
end