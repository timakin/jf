class String
    def numstr_to_i
        is_int?(self) ? to_i : self
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
        size == 1
    end
end

class Hash
    def slice(*keys)
        keys.map! { |key| convert_key(key) } if respond_to?(:convert_key, true)
        keys.each_with_object(self.class.new) { |k, hash| hash[k] = self[k] if key?(k) }
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
        keys.each_with_object(self.class.new) { |key, result| result[key] = delete(key) if key?(key) }
    end

    def insert_after(key, obj)
        splitter = keys.index(key)
        before_keys = keys[0..splitter]
        before = extract!(*before_keys)
        after = slice!(*before_keys)
        merged = before.merge(obj).merge(after)
        merged
    end

    def deep_merge(*keys, val)
        if keys.last == 'all'
            keys.pop
            merge_target = keys.inject(self) { |h, k| h[k.numstr_to_i] }
            merge_target.each_with_index do |value, index|
                keys.inject(self) { |h, k| h[k.numstr_to_i] }[index] = value.merge(val)
            end
            return self
        end
        merge_target = keys.inject(self) { |h, k| h[k.numstr_to_i] }
        if keys.one?
            self[keys.last] = if self[keys.last].is_a?(Hash)
                                  merge_target.merge(val)
                              else
                                  val
                              end
        else
            if merge_target.is_a?(Array)
                merge_to_array(*keys, merge_target, val)
            elsif merge_target.is_a?(Hash)
                merge_to_hash(*keys, merge_target, val)
            else # if merge_target is a kind of String
                replace(*keys, merge_target, val)
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

    def replace(*keys, _target, val)
        last_key = keys.pop
        keys.inject(self) { |h, k| h[k.numstr_to_i] }[last_key.numstr_to_i] = val
    end
end
