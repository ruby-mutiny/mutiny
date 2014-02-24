# This spec doesn't (necessarily) exercise any the code defined in Mutiny,
# but rather tests the requirements of the library we use to define
# value objects. Currently, we use a bespoke mixin (Valuable), but previous
# versions of the code used the key_struct gem, and Ruby structs.

require "mutiny/valuable/valuable"

module Mutiny
  
  # Fixtures
  class User;    extend Valuable; attributes :id, :forename, surname: "Bloggs" end
  class Patient; extend Valuable; attributes :id, :forename, surname: "Bloggs" end
  
  describe "ValueObjects" do
    describe "construction" do
      it "should accept a hash" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        
        expect(i.id).to eq(1)
        expect(i.forename).to eq('John')
        expect(i.surname).to eq('Doe')
      end

      it "should set missing attributes to default" do
        i = User.new(forename: 'John')
        
        expect(i.id).to be_nil
        expect(i.forename).to eq('John')
        expect(i.surname).to eq('Bloggs')
      end
    
      it "should set missing attributes without defaults to nil" do
        i = User.new(surname: 'Doe')
        
        expect(i.id).to be_nil
        expect(i.forename).to be_nil
        expect(i.surname).to eq('Doe')
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
      it "should provide a working eql? method" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        j = User.new(id: 1, forename: 'John', surname: 'Doe')
      
        expect(i).to eql(j)
      end
      
      it "should provide a working == method" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        j = User.new(id: 1, forename: 'John', surname: 'Doe')
      
        expect(i).to be == j
      end
      
      it "should distinguish between objects with different attribute values" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        j = User.new(id: 1, forename: 'Jane', surname: 'Doe')
      
        expect(i).not_to eql(j)
        expect(i).not_to be == j
      end
      
      it "should distinguish between objects with different types and same attribute values" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        j = Patient.new(id: 1, forename: 'John', surname: 'Doe')
      
        expect(i).not_to eql(j)
        expect(i).not_to be == j
      end
    end
    
    describe "hash" do
      it "should ensure that objects with the same attribute values have the same hash" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        j = User.new(id: 1, forename: 'John', surname: 'Doe')
        
        expect(i.hash).to eq(j.hash)
      end
      
      it "should ensure that objects with different attribute values have different hashes" do
        a = User.new(id: 1, forename: 'John', surname: 'Doe')
        b = User.new(id: nil, forename: 'John', surname: 'Doe')
        c = User.new(id: 1, forename: nil, surname: 'Doe')
        d = User.new(id: 1, forename: 'John', surname: nil)
        
        hashes = [a,b,c,d].map { |user| user.hash }
        
        expect(hashes.uniq).to eq(hashes)
      end
    end
    
    describe "inspect" do
      it "should emit type and attribute values" do
        i = User.new(id: 1, forename: 'John', surname: 'Doe')
        
        expect(i.inspect).to eq("<Mutiny::User id=1, forename=\"John\", surname=\"Doe\">")
      end
    end
    
    describe "specialises" do
      it "should pull in attributes from specified class" do
        class SuperUser
          extend Valuable

          attributes :password, active: true
          specialises User
        end
        
        s = SuperUser.new(id: 1, forename: 'Bob', password: 'secret', active: false)
        
        expect(s.id).to eq(1)
        expect(s.forename).to eq('Bob')
        expect(s.surname).to eq('Bloggs')
        expect(s.password).to eq('secret')
        expect(s.active).to be_false
      end
      
      it "should be possible to declare specialisation before attributes" do
        class SuperUser
          extend Valuable

          specialises User
          attributes :password, active: true
        end
        
        s = SuperUser.new(id: 1, forename: 'Bob', password: 'secret', active: false)
        
        expect(s.id).to eq(1)
        expect(s.forename).to eq('Bob')
        expect(s.surname).to eq('Bloggs')
        expect(s.password).to eq('secret')
        expect(s.active).to be_false
      end
      
      it "should ensure that local attributes have greater precedence than specialised attributes" do
        class SuperUser
          extend Valuable

          specialises User
          attributes surname: 'Smith'
        end
        
        s = SuperUser.new
        
        expect(s.surname).to eq('Smith')
      end
      
      it "should ensure that local attributes have greater precedence than specialised attributes, even if specialisation is declared after local attributes" do
        class SuperUser
          extend Valuable

          attributes surname: 'Smith'
          specialises User
        end
        
        s = SuperUser.new
        
        expect(s.surname).to eq('Smith')
      end
      
      it "should raise if specialising class is not an instance of Valuable" do
        expect do
          class SuperUser
            extend Valuable
            specialises String
          end
        end.to raise_error(ArgumentError, "specialisation requires a class that extends Valuable")
      end
    end
  end
end