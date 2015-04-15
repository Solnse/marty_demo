class MartyDemo::Config < MartyDemo::Base
  validates_presence_of :key, :value
  validates_uniqueness_of :key

  delorean_fn :lookup, sig: 1 do
    |key|
    self[key]
  end

  def self.[]=(key, value)
    entry = find_by_key(key)
    if !entry
      entry = self.new
      entry.key = key
    end

    entry.value = value.to_json
    entry.save!

    value
  end

  def self.[](key)
    entry = find_by_key(key)
    entry and entry.get_value
  end

  def self.del(key)
    entry = find_by_key(key)
    if entry
      result = entry.get_value
      entry.destroy
      result
    end
  end
end
