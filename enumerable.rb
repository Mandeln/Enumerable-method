module Enumerable
  def my_each(&block)
    return unless block_given?

    each(&block)
    self
  end
end

def my_each_with_index
  return unless block_given?

  i = 0
  each do |something|
    yield(something, i)
    i += 1
  end
  self
end

def my_select
  return unless block_given?

  arr = []
  my_each do |something|
    arr.push(something) if yield(something)
  end
  arr
end

def my_all?
  return unless block_given?

  condition = true
  my_each do |something|
    condition = false unless yield(something)
  end
  condition
end

def my_any?
  return unless block_given?

  condition = false
  my_each do |something|
    condition = true if yield(something)
  end
  condition
end

def my_none?
  return unless block_given?

  condition = false
  my_each do |something|
    condition = true unless yield(something)
  end
end

def my_count
  return length unless block_given?

  counter = 0
  my_each do |something|
    counter += 1 if yield(something)
  end
  counter
end

def my_map(proc = nil)
  mapping = []
  if !proc.nil?
    my_each do |something|
      mapping.push(proc.call(something))
    end
  else
    my_each do |something|
      mapping.push(yield(something))
    end
  end
  mapping
end

def my_inject(initial = nil)
  result = initial.nil? ? self[0] : initial
  i = initial.nil? ? 1 : 0
  self[i...length].my_each do |something|
    result = yield(result, something)
  end
  result
end
