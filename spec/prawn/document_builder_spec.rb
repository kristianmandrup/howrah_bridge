require File.expand_path(__FILE__, "../spec_helper")

module Howrah::Prawn
  describe DocumentBuilder do                 
    context "default build options" do    
      it "should build a prawn document" do
        doc = DocumentBuilder.build
        doc.should be_a_kind_of ::Prawn::Document
        doc.page.size.should == DocumentBuilder.default_options[:page_size]
      end      

      it "should build a prawn document using default options of page size A5" do
        DocumentBuilder.default_options = {:page_size => "A5"}
        doc = DocumentBuilder.build        
        doc.should be_a_kind_of ::Prawn::Document
        doc.page.size.should == "A5"
      end      

      it "should build a prawn document with page size A5" do
        doc = DocumentBuilder.build :page_size => "A5"
        doc.should be_a_kind_of ::Prawn::Document
        doc.page.size.should == "A5"
      end      
    end
  end
end