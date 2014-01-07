require "ast_replacer"

describe AstReplacer, "replace" do
  before(:each) do
    @replacer = AstReplacer.new do |old_ast|
      Parser::CurrentRuby.parse("foo")
    end
  end
  
  it "should replace root" do
    ast = Parser::CurrentRuby.parse("a.b.c.d")
    @replacer.replace(ast, []).should eq(Parser::CurrentRuby.parse("foo"))
  end
  
  it "should replace immediate first child" do
    ast = Parser::CurrentRuby.parse("a.b.c.d")
    @replacer.replace(ast, [0]).should eq(Parser::CurrentRuby.parse("foo.d"))
  end
  
  it "should replace immediate last child" do
    ast = Parser::CurrentRuby.parse("a.b")
    @replacer = AstReplacer.new do |old_ast|
      :foo # last child is :b which is a symbol, not a Node
    end
    @replacer.replace(ast, [1]).should eq(Parser::CurrentRuby.parse("a.foo"))
  end
end