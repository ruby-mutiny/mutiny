require "mutiny/attributable"

module Mutiny
  class User
    extend Attributable
    
    attributes :id, :forename, :surname
  end
  
  class Admin
    extend Attributable
    
    attributes :id, :forename, :surname
  end
  
  describe Attributable do
    describe "construction" do
      it "should accept a hash" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        
        expect(i.id).to eq(1)
        expect(i.forename).to eq('John')
        expect(i.surname).to eq('Doe')
      end
    
      it "should set missing attributes to nil" do
        i = User.new(forename: 'John')
        
        expect(i.id).to be_nil
        expect(i.forename).to eq('John')
        expect(i.surname).to be_nil
      end
    end
    
    describe "attributes" do
      it "should raise for an unknown attribute" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        expect(i.respond_to?(:address)).to be_false
      end 
    
      it "should not have setters" do
        i = User.new(forename: 'John')
      
        expect(i.respond_to?(:id=)).to be_false
      end
    end
    
    describe "equality" do
      it "should be a value object" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        j = User.new(id: 1, forename: 'John', surname: 'Doe')
      
        expect(i).to eq(j)
      end
      
      it "should distinguish between objects with different attribute values" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        j = User.new(id: 1, forename: 'Jane', surname: 'Doe')
      
        expect(i).not_to eq(j)
      end
      
      it "should distinguish between objects with same attribute but of different classes" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        j = Admin.new(id: 1, forename: 'John', surname: 'Doe')
      
        expect(i).not_to eq(j)
      end
    end
  end
end