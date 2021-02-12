module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    to_a.length.times do |i|
      yield to_a[i]
      i + 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    to_a.length.times do |i|
      yield(to_a[i], i)
      i + 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = []
    my_each { |something| arr << something if yield something }
    arr
  end

  def my_all?(param = nil)
    if block_given?
      to_a.my_each { |something| return false if yield(something) == false }
      return true
    elsif param.nil?
      to_a.my_each { |something| return false if something.nil? || something == false }
    elsif !param.nil? && (param.is_a? Class)
      to_a.my_each { |something| return false unless [something.class, something.class.superclass].include?(param) }
    elsif !param.nil? && param.instance_of?(Regexp)
      to_a.my_each { |something| return false unless param.match(something) }
    else
      to_a.my_each { |something| return false if something != param }
    end
    true
  end

  def my_any?(param = nil)
    if block_given?
      to_a.my_each { |something| return true if yield(something) }
      return false
    elsif param.nil?
      to_a.my_each { |something| return true if something }
    elsif !param.nil? && (param.is_a? Class)
      to_a.my_each { |something| return true if [something.class, something.class.superclass].include?(param) }
    elsif !param.nil? && param.instance_of?(Regexp)
      to_a.my_each { |something| return true if param.match(something) }
    else
      to_a.my_each { |something| return true if something == param }
    end
    false
  end

  def my_none?(argum = nil)
    if !block_given? && argum.nil?
      my_each { |i| return false if i }
      return true
    end

    if !block_given? && !argum.nil?

      if argum.is_a?(Class)
        my_each { |i| return false if i.instance_of?(argum) }
        return true
      end

      if argum.instance_of?(Regexp)
        my_each { |i| return false if argum.match(i) }
        return true
      end

      my_each { |i| return false if i == argum }
      return true
    end
    my_any? { |something| return false if yield(something) }
    true
  end

  def my_count(param = nil)
    j = 0
    if block_given?
      to_a.my_each { |item| j += 1 if yield(item) }
    elsif !block_given? && param.nil?
      j = to_a.length
    else
      j = to_a.my_select { |something| something == param }.length
    end
    j
  end

  def my_map(proc_x = nil)
    return enum_for unless block_given?

    mapping = []
    if proc_x.nil?
      my_each { |something| mapping.push(yield(something)) }
    else
      my_each { |something| mapping.push(proc_x.call(something)) }
    end
    mapping
  end

  def my_inject(initial = nil, sym = nil)
    if (!initial.nil? && sym.nil?) && (initial.is_a?(Symbol) || initial.is_a?(String))
      sym = initial
      initial = nil
    end
    if !block_given? && !sym.nil?
      to_a.my_each { |something| initial = initial.nil? ? something : initial.send(sym, something) }
    else
      to_a.my_each { |something| initial = initial.nil? ? something : yield(initial, something) }
    end
    initial
  end
end

def multiply_els(par)
  par.my_inject(1) { |a, b| a * b }
end
