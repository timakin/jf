class String
  def numstr_to_i
    is_int?(self) ? self.to_i : self
  end

  def is_int?(str)
    Integer(str)
    true
  rescue ArgumentError
    false
  end
end

class Array
  def one?
    self.size == 1
  end
end

class Hash
  def slice(*keys)
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
    keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if has_key?(k) }
  end

  def slice!(*keys)
    keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
    omit = slice(*self.keys - keys)
    hash = slice(*keys)
    hash.default      = default
    hash.default_proc = default_proc if default_proc
    replace(hash)
    omit
  end

  def extract!(*keys)
    keys.each_with_object(self.class.new) { |key, result| result[key] = delete(key) if has_key?(key) }
  end

  def insert_after(key, obj)
    splitter = self.keys.index(key)
    before_keys = self.keys[0..splitter]
    before = self.extract!(*before_keys)
    after = self.slice!(*before_keys)
    merged = before.merge(obj).merge(after)
    merged
  end

  def deep_merge(*keys, val)
    merge_target = keys.inject(self) { |h, k| h[k.numstr_to_i] }
    if keys.one?
      self[keys.last] = merge_target.merge(val)
    else
      if merge_target.kind_of?(Array)
        merge_to_array(*keys, merge_target, val)
      else
        merge_to_hash(*keys, merge_target, val)
      end
    end
    self
  end

  private

  def merge_to_array(*keys, target, val)
    last_key = keys.pop
    keys.inject(self) { |h, k| h[k.numstr_to_i] }[last_key.numstr_to_i] = target.push(val)
  end

  def merge_to_hash(*keys, target, val)
    last_key = keys.pop
    keys.inject(self) { |h, k| h[k.numstr_to_i] }[last_key.numstr_to_i] = target.merge(val)
  end
end
