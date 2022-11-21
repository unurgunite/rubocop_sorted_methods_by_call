# frozen_string_literal: true

class Hash # :nodoc:
  # +Hash#to_a+                                       -> Array
  #
  # This method transforms each hash value into array and call original #to_a
  # method.
  #
  # @return [Array]
  def values_and_self_to_array!
    transform_values! { |v| Array(v) }.to_a
  end
end
