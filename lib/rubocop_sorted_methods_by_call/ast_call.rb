# frozen_string_literal: false

require "parser/current"

module RubocopSortedMethodsByCall
  # The +Processor+ class is corresponding for analyzing method
  # definition/call trace.
  class Processor < AST::Processor
    attr_reader :trace, :methods_list

    # @return [Array]
    def initialize
      super
      @trace = []
      @methods_list = []
    end

    # +Processor#on_begin(node)+                        -> Array
    #
    # @param [AST::Node] node An object representing node
    # @return [Array]
    #
    # @see AST::Node#on_begin
    def on_begin(node)
      node.children.each do |c|
        process(c)
      end
    end

    # +Processor#handler_missing(node)+                 -> String
    #
    # @param [AST::Node] node An object representing node
    # @return [String, nil]
    #
    # @see AST::Node#handler_missing
    def handler_missing(node)
      puts "missing #{node.type}"
    end

    # +Processor#on_def(node)+                          -> Object
    #
    # @param [Object] node
    # @return [Object]
    #
    # @see AST::Node#on_def
    def on_def(node)
      @methods_list << node.children.first
      invoked_methods = node.children[2]
      invoked_methods.children.each do |c|
        return @trace << c if c.is_a? Symbol

        on_send(c) if c.type == :send
      rescue NoMethodError
        next
      end
    end

    # +Processor#on_send(node)+                         -> Array
    #
    # @param [Object] node
    # @return [Array]
    #
    # @see AST::Node#on_send
    def on_send(node)
      @trace << node.children[1]
    end

    # +Processor#ordered?+                              -> TrueClass, FalseClass
    #
    # This method was made to check if methods in AST are defined in right order.
    # The right order in our case is defined by stack trace or by method call
    # position in other words.
    #
    # @return [TrueClass, FalseClass]
    def ordered?
      @methods_list & @trace == @trace
    end
  end
end
