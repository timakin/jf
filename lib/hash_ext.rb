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

  def deep_insert(obj, *keys)
    current = self[keys.shift]
    # p obj
    p keys
    p self
    p current
    p "===================="
    if keys.size == 1
      current = obj
    else
      case current.class
      when String
        self
      when Array
        current.each do |i,v|
          cloned_keys = Marshal.load(Marshal.dump(keys))
          current[i].deep_insert(obj, cloned_keys)
        end
      when Hash
        if current.has_key?(keys[0])
          current.deep_insert(obj, keys)
        else
          self
        end
      else
        self
      end
    end
    p obj
    p keys
  end
end
