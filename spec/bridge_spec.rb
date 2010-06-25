require 'spec_helper'

describe Howrah::Bridge do
  let (:file_name_1)        { 'doc_1.pdf' }
  let (:file_name_2)        { 'doc_2.pdf' }
  let (:html)               { '<p>Hello</p>' }   
        
  before(:each) do
    @bridge_class = Howrah::Bridge
    @doc = Prawn::Document.new(:page_size => "A4")    

    @doc2 = Prawn::Document.new(:page_size => "A4")    
    @bridge = @bridge_class.new :prawn_document => @doc2
  end

  context "Create a new bridge" do
    it "should raise a warning when ! options.kind_of?(Hash)" do
      lambda { 
        Howrah::Bridge.new []
      }.should raise_error(ArgumentError, "Supplied options must be of type Hash.")
    end
      
    it "should create bridge from a file name" do
      @bridge_class.new :file_name => file_name_1 do |bridge|
        bridge.file_name.should == file_name_1    
      end    
    end   
      
    it "should change file name using accessor" do
      @bridge_class.new :file_name => file_name_1 do |bridge|
        bridge.file_name = file_name_2        
        bridge.file_name.should == file_name_2
      end    
    end   
  
    it "should create bridge from a doc" do    
      @bridge_class.new :prawn_document => @doc do |bridge|  
        bridge.prawn_document.should == @doc 
      end    
    end   
    
    it "should override default document options if filename used to initialize" do    
      @bridge_class.new :file_name => file_name_1, :page_size => "A5" do |bridge|
        bridge.prawn_document.page.size.should == "A5"
      end    
    end   
    
    it "should create a new instance of state" do
      @state = Howrah::State::Manager.new :file_name => file_name_1
      # Howrah::State::Manager.should_receive(:new).and_return(@state)
    
      @bridge = Howrah::Bridge.new :file_name => file_name_1
      # @bridge.state.should_not be_nil
    end
    
  end  
    
end
