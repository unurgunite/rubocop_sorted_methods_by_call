# frozen_string_literal: true

class Hash # :nodoc:
  # +Hash#eql?+                                       -> TrueClass, FalseClass
  #
  # This method checks if hashes are identical.
  #
  # @overload eql?(other)
  # @param [Hash] other Hash object.
  # @return [NilClass] if +other+ is not a Hash.
  # @return [TrueClass] if hashes are identical.
  # @return [FalseClass] if hashes are not identical.
  def eql?(other)
    return unless other.is_a? Hash

    to_a
    other.to_a
    values.each_with_index do |arr, i|
      next if arr & (v = other.values[i]) == v

      return false
    end
    true
  end
end
