class Array
  
  def to_hash
    new_hash = {}
    each { |x,y| new_hash[x] = y }
    new_hash
  end
  
  def index_by
    new_hash = {}
    each { |x| new_hash[yield(x)] = x }
    new_hash
  end
  
  def subarray_count(subarray)
    count = 0
    each_cons(subarray.length) do |sub|
      sub == subarray ? count += 1 : next
    end
    count
  end
    
  def occurences_count
    new_hash = Hash.new(0)
    each { |x,y| new_hash[x] += 1 }
    new_hash
  end
end
