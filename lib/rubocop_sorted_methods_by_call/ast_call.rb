# frozen_string_literal: true

require "parser/current"

module RubocopSortedMethodsByCall
  # The +Processor+ class is corresponding for analyzing method
  # definition/call trace.
  class Processor < AST::Processor
    attr_reader :trace, :methods_list

    # +@trace+ Represents expected AST nodes.
    # +@methods_list+ Represents real AST nodes.
    # @return [Array]
    def initialize
      super
      @trace = []
      @methods_list = []
    end

    # +Processor#on_begin(node)+                      -> Array
    #
    # This method is invoked when +Processor+ object encounters a +:begin+ AST
    # structure during tree parsing. It handles the root of AST, so we should
    # to iterate through its children to find out other nodes to get access to
    # their attributes.
    #
    # @api private
    # @overload on_begin(node)
    # @param [AST::Node] node An object representing node.
    # @return [Array]
    #
    # @see AST::Node#on_begin
    def on_begin(node)
      node.children.each do |c|
        process(c)
      end
    end

    # +Processor#handler_missing(node)+               -> String
    #
    # This method is invoked when +Processor+ object encounters unhandled AST
    # structure. If there is no handler for node type, this method will be
    # invoked immediately.
    #
    # @api private
    # @overload handler_missing(node)
    # @param [AST::Node] node An object representing node.
    # @return [String, nil]
    #
    # @see AST::Node#handler_missing
    def handler_missing(node)
      puts "missing #{node.type}"
    end

    # +Processor#on_def(node)+                        -> Object
    #
    # This method is invoked when +Processor+ object encounters a +:def+ AST
    # node during tree parsing. It represents method definition in object's
    # message protocol. Current implementation of this handler processing method
    # names in real AST. It handles method names in trace when they are invoked
    # in single-line methods as well as with multi-line methods.
    #
    # @api private
    # @overload on_def(node)
    # @param [Object] node An object representing +:def+ node.
    # @raise [NoMethodError] if child is not real node.
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

    # +Processor#on_send(node)+                       -> Array
    #
    # This method is invoked during +:send+ instruction during AST parsing.
    # According to Alan Kay's theory of object computation, each object can
    # receive and send messages to other objects representing objects in
    # real life. Ruby has the same object representation such as Smalltalk and
    # other message-oriented languages. Current method puts into array method
    # names in real AST.
    #
    # @api private
    # @overload on_send(node)
    # @param [Object] node An object representing +:send+ node.
    # @return [Array]
    #
    # @see AST::Node#on_send
    def on_send(node)
      @trace << node.children[1]
    end

    # +Processor#ordered?+                            -> TrueClass, FalseClass
    #
    # This method was made to check if methods in AST are defined in right order.
    # The right order in our case is defined by stack trace or by method call
    # position in other words. It compares real AST nodes with expected.
    #
    # @return [TrueClass, FalseClass]
    def ordered?
      @methods_list & @trace == @trace
    end
  end
end
