module Howrah
  module State
    class Table
      attr_accessor :caption, :header, :body, :footer, :cells
      
      def initialize
        @caption = nil
        @header = []
        @body = []  
        @footer = []      
        @cells = []
      end
      
      def clear_cells
        @cells = []        
      end 

      # TODO: make DRY using define_method
      def header?
        !header.empty?
      end

      def cells?
        !cells.empty?
      end

      def footer?
        !footer.empty?
      end

      def body?
        !body.empty?
      end

    end
  end
end
      
    