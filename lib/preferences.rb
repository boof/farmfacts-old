class Preferences
  include Singleton

  def self.[](key)
    const_get(key).try :instance
  end

  def self.path
    raise NotImplementedError
  end

  def valid?
    raise NotImplementedError
  end

  def initialize
    @data = YAML.load_file self.class.path
  end

  def attributes
    @data
  end
  def attributes=(attributes)
    return unless attributes.is_a? Hash
    attributes.each { |attr, value| self.send :"#{ attr }=", value }
  end

  def save
    yaml = YAML.dump @data.to_hash
    File.open(self.class.path, 'w') { |file| file << yaml }
  end

end
