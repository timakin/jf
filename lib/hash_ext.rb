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

  def deep_insert(*keys, key, val)
    if keys.empty?
      self[key] = val
    else
      keys.inject(self) { |h, k| h[k] }[key] = val
    end
  end

  def deep_merge(*keys, val)
    if keys.size == 1
      self[keys.last] = keys.inject(self) { |h, k| h[k] }.merge(val)
    else
      # under development
      last_key = keys.pop
      p last_key
      p keys
      p self
      p keys.inject(self) { |h, k| h[k] }.merge(val)
      p keys.inject(self) { |h, k| h[k] }[last_key]
      keys.inject(self) { |h, k| h[k] }[last_key] = keys.inject(self) { |h, k| h[k] }.merge(val)
    end
    self
  end
end
