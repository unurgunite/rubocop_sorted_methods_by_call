# frozen_string_literal: true

RSpec.describe RubocopSortedMethodsByCall::Processor do
  describe "#ordered?" do
    context "when methods are in right order" do
      let(:code) { Parser::CurrentRuby.parse(File.read("spec/ast_file_correct.rb")) }

      it "should return true" do
        tree = described_class.new
        tree.process(code)
        expect(tree.ordered?).to be true
      end
    end

    context "when methods are in wrong order" do
      let(:code) { Parser::CurrentRuby.parse(File.read("spec/ast_file_wrong.rb")) }

      it "should return false" do
        tree = described_class.new
        tree.process(code)
        expect(tree.ordered?).to be false
      end
    end
  end
end
