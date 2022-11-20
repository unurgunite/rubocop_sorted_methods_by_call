class Array # :nodoc:
  # +Array#subset?+                                   -> TrueClass, FalseClass
  # 
  # This method checks if one array is a subset of another. It pays attention
  # for elements order.
  # 
  # @example
  #   a = [1, 2, 3, 4, 5, 6]
  #   subset_1 = [1, 2, 3]
  #   a.subset?(subset_1) #=> true
  #   subset_2 = [1, 3, 2]
  #   a.subset?(subset_2) #=> false
  # 
  # @param [Array] arr Some array.
  # @return [TrueClass] if +arr+ is a subset of +self+.
  # @return [FalseClass] if +arr+ is not a subset of +self+.
  def subset?(arr)
    each_cons(arr.length).any?(&arr.method(:==))
  end
end