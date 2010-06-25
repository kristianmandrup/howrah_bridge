module Howrah
  module Prawn
    class DocumentBuilder      

      class << self
        attr_accessor :default_options        

        def default_options    
          @default_options ||= {:page_size => "A4"}
        end      
        
        def build(options = {})
          ::Prawn::Document.new default_options.merge(options)        
        end
      end
    end
  end
end
