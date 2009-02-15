class Preferences::FarmFacts < Preferences

  @path = Rails.root.join 'config', 'farmfacts.yml'
  def self.path; @path end


  def valid?
    !name.blank?
  end

  def name
    @data.fetch 'name', "dfn\037oq`drsn\037dh\037ldtr\037`mhltr".split(//).each { |c| c.succ! }.to_s
  end
  def name=(name)
    @data['name'].replace name
  end

  def server_recipients
    @data.fetch 'server_recipients', ['admin@localhost']
  end
  def server_recipients=(*recipients)
    @data['server_recipients'].replace recipients
  end

  def server_sender
    @data.fetch 'server_sender', 'server@localhost'
  end
  def server_sender=(sender)
    @data['server_sender'].replace sender
  end

  def frontpage_path
    @data.fetch 'frontpage_path', '/'
  end
  def frontpage_path=(path)
    @data['frontpage_path'].replace path
  end

  def metadata
    @data.fetch 'metadata', {}
  end
  def metadata=(data)
    @data['metadata'] = data
  end

end
