require "ast/match"

module Ast
  describe Match do
    describe "matched" do
      it "should return the entire AST when the location is empty" do
        match = match_for("foo.bar", [])
      
        expect(match.matched).to eq(match.ast)
      end
    
      it "should return the appropriate sub-AST when the location is non-empty" do
        match = match_for("def run\nfoo.bar\nbaz.baaz\nend", [2, 1])
      
        expect(match.matched).to eq(match.ast.children[2].children[1])
      end
    
      it "should error on non-existent element" do
        match = match_for("foo.bar", [2])
      
        expect { match.matched }.to raise_error
      end
    end
  
    describe "child" do
      it "should descend to child" do
        original = match_for("foo.bar", [0])
        child = match_for("foo", [])
      
        expect(original.child).to eq(child)
      end
    
      it "should return nil when match is for root" do
        match = match_for("foo.bar", [])
      
        expect(match.child).to be_nil
      end
    end
    
    describe "replace" do
      it "should replace root" do
        match = match_for("foo.bar", [])
        replaced = match.replace { parse("a") }

        expect(replaced).to eq(match_for("a", []))
      end
    
      it "should replace nested element" do
        match = match_for("foo.bar.baz", [0, 0])
        replaced = match.replace { parse("a") }

        expect(replaced).to eq(match_for("a.bar.baz", [0, 0]))
      end
    
      it "should provide helper for easily replacing children of match" do
        match = match_for("foo.bar.baz", [0, 0])
        replaced = match.replace { |helper| helper.replace_child(1, :a) }

        expect(replaced).to eq(match_for("a.bar.baz", [0, 0]))
      end
    
      it "should replace last child" do
        match = match_for("foo.bar.baz", [1])
        replaced = match.replace { :a }

        expect(replaced).to eq(match_for("foo.bar.a", [1]))
      end
    end
    
    def match_for(source, location)
       Match.new(parse(source), location)
    end
  
    def parse(source)
      Parser::CurrentRuby.parse(source)
    end
  end
end