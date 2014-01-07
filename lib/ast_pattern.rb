class AstPattern
  attr_reader :matcher
  
  def initialize(&matcher)
    @matcher = matcher
  end
  
  def match(ast, location = [])
    matches = []
    matches << MatchResult.new(ast, location) if matcher.call(ast)
    matches << match_children(ast, location)
    matches.flatten
  end
  
private
  def match_children(ast, location)
    ast.children
      .each_with_index
      .map { |child, index| match(child, location.dup << index) if child.is_a? Parser::AST::Node }
      .compact
  end
end

class MatchResult
  attr_reader :matched, :location
  
  def initialize(matched, location)
    @matched = matched
    @location = location
  end
end