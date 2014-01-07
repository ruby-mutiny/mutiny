require "ast/pattern"

module Ast
  describe Pattern, "match" do
    before(:each) do
      @pattern = Pattern.new do |node|
        node.type == :send && node.children.first != nil
      end
    end
  
    it "should find immediate matches" do
      ast = Parser::CurrentRuby.parse("foo.bar")
      matches = @pattern.match(ast)
    
      matches.size.should eq(1)
      matches.first.matched.should eq(ast)
      matches.first.location.should eq([])
    end
  
    it "should find immediate and subsequent matches" do
      ast = Parser::CurrentRuby.parse("foo.bar.baz")
      matches = @pattern.match(ast)
    
      matches.size.should eq(2)
      matches[0].matched.should eq(ast)
      matches[0].location.should eq([])
    
      matches[1].matched.should eq(ast.children.first)
      matches[1].location.should eq([0])
    end
  
    it "should find child matches" do
      ast = Parser::CurrentRuby.parse("def run\nfoo.bar\nend")
      matches = @pattern.match(ast)
    
      matches.size.should eq(1)
      matches.first.matched.should eq(ast.children.last)
      matches.first.location.should eq([2])
    end
  
    it "should find all child matches" do
      ast = Parser::CurrentRuby.parse("def run\nfoo.bar\nx.y\nend")
      matches = @pattern.match(ast)
   
      body = ast.children.last

      matches.size.should eq(2)
      matches[0].matched.should eq(body.children.first)
      matches[0].location.should eq([2, 0])

      matches[1].matched.should eq(body.children.last)
      matches[1].location.should eq([2, 1])
    end
  
    it "should work within a class" do
      ast = Parser::CurrentRuby.parse("class Simple\ndef run\nfoo.bar\nend\nend")
      matches = @pattern.match(ast)
    
      matches.size.should eq(1)
      matches.first.matched.should eq(ast.children.last.children.last)
      matches.first.location.should eq([2, 2])
    end
  end
end