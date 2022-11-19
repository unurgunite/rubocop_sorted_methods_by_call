# frozen_string_literal: true

class Hash # :nodoc:
  # +Hash#to_a+                                       -> Array
  #
  # This method transforms each hash value into array and call original #to_a
  # method.
  #
  # @overload to_a
  # @return [Array]
  def to_a
    transform_values! { |v| Array(v) }
    super
  end
end
