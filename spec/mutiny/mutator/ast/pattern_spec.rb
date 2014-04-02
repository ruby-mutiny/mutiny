require "mutiny/mutator/ast/pattern"
require "mutiny/domain/region"
require "parser/current"

module Mutiny
  module Mutator
    module Ast
      describe Pattern, "match" do
        before(:each) do
          @pattern = Pattern.new do |node|
            node.type == :send && !node.children.first.nil?
          end
        end

        it "should find immediate matches" do
          ast = ::Parser::CurrentRuby.parse("foo.bar")
          matches = @pattern.match(ast)

          expect(matches.size).to eq(1)
          expect(matches.first.matched).to eq(ast)
          expect(matches.first.location).to eq([])
        end

        it "should find immediate and subsequent matches" do
          ast = ::Parser::CurrentRuby.parse("foo.bar.baz")
          matches = @pattern.match(ast)

          expect(matches.size).to eq(2)
          expect(matches[0].matched).to eq(ast)
          expect(matches[0].location).to eq([])

          expect(matches[1].matched).to eq(ast.children.first)
          expect(matches[1].location).to eq([0])
        end

        it "should find child matches" do
          ast = ::Parser::CurrentRuby.parse("def run\nfoo.bar\nend")
          matches = @pattern.match(ast)

          expect(matches.size).to eq(1)
          expect(matches.first.matched).to eq(ast.children.last)
          expect(matches.first.location).to eq([2])
        end

        it "should find all child matches" do
          ast = ::Parser::CurrentRuby.parse("def run\nfoo.bar\nx.y\nend")
          matches = @pattern.match(ast)

          body = ast.children.last

          expect(matches.size).to eq(2)
          expect(matches[0].matched).to eq(body.children.first)
          expect(matches[0].location).to eq([2, 0])

          expect(matches[1].matched).to eq(body.children.last)
          expect(matches[1].location).to eq([2, 1])
        end

        it "should work within a class" do
          ast = ::Parser::CurrentRuby.parse("class Simple\ndef run\nfoo.bar\nend\nend")
          matches = @pattern.match(ast)

          expect(matches.size).to eq(1)
          expect(matches.first.matched).to eq(ast.children.last.children.last)
          expect(matches.first.location).to eq([2, 2])
        end

        it "should be possible to scope matches to a region" do
          scope = Mutiny::Region.new(start_line: 2, end_line: 3)
          ast = ::Parser::CurrentRuby.parse("foo.bar\nbar.baz\nbaz.baaz")
          matches = @pattern.match(ast, scope)

          expect(matches.size).to eq(2)
          expect(matches[0].matched).to eq(ast.children[1])
          expect(matches[0].location).to eq([1])

          expect(matches[1].matched).to eq(ast.children[2])
          expect(matches[1].location).to eq([2])
        end
      end
    end
  end
end
