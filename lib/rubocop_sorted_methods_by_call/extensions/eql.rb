# frozen_string_literal: true

class Hash # :nodoc:
  # +Hash#eql?+                                       -> TrueClass, FalseClass
  #
  # This method checks if hashes are identical. Complexly, it turns +self+ 
  # values as well as +other+ param values into array via override 
  # Hash#to_a method. At next step it starts iterating through +self+ values to 
  # compare general slice of them and values of +other+ hash.
  # 
  # @example
  #    def abc
  #      foo
  #      bar
  #    end
  # 
  #    # positive case  # negative case
  #      def foo; end     def foo; end
  #      def bar; end     def c; end
  #      def c; end       def bar; en
  # @overload eql?(other)
  # @param [Hash] other Hash object.
  # @return [NilClass] if +other+ is not a Hash.
  # @return [TrueClass] if hashes are identical.
  # @return [FalseClass] if hashes are not identical.
  def eql?(other)
    return unless other.is_a? Hash

    [self, other].each(&:to_a)
    values.each_with_index do |arr, i|
      if (general_slice = arr & (val = other.values[i])) == val || val.any? { |el| !arr.include?(el) }
        return false unless arr.subset?(general_slice)

        next
      end
      return false
    end
    true
  end
end
