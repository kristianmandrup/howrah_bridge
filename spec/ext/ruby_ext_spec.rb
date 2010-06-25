require File.expand_path(__FILE__, "../spec_helper")

describe "String extensions" do              
  it "should camelize string correctly" do
    @hello = "hello_world"
    @hello.camelize.should == "HelloWorld"
  end   

  it "should camelize namespace by throwing out ::" do
    @hello = "hello::world"
    @hello.camelize.should == "HelloWorld"
  end   

  it "should underscore string correctly" do
    @hello = "hello-world"
    @hello.underscore.should == "hello_world"
  end   
end

describe "Symbol extensions" do              
  it "should camelize symbol correctly" do
    @hello = :hello_world
    @hello.camelize.should == "HelloWorld"
  end   
end

class Inflect
  include ::Howrah::SimpleInflector
end
        
describe Howrah::SimpleInflector do         
  it "should constantize string correctly" do
    constant = "Howrah::SimpleInflector"
    Howrah::SimpleInflector.get_const(constant).should == ::Howrah::SimpleInflector
    Inflect.new.constantize(constant).should == ::Howrah::SimpleInflector
  end   
end

  
