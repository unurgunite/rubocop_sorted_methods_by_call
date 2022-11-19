# frozen_string_literal: true

class Hash # :nodoc:
  # +Hash#deep_merge(other)                           -> Hash
  #
  # This method merges two hashes without overriding identical keys during
  # name pollutions.
  #
  # @example
  #   a = {:main=>[:abc], :class_T=>[:hi]}
  #   b = {:class_T=>:h1}
  #   a.deep_merge(b) #=>  {:main=>[:abc], :class_T=>[:hi, :h1]} # values are stored in 'buckets'
  # @param [Hash] other Some hash.
  # @return [NilClass] if +other+ is not a Hash object.
  # @return [Hash]
  def deep_merge(other)
    return unless other.is_a? Hash

    merge!(other) { |_, old_value, new_value| [*old_value].to_a + [*new_value].to_a }
  end
end
