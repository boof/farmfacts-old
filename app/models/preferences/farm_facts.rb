class Preferences::FarmFacts < Preferences

  has_one :metadata

  def preferences
    data ||= {
      'name'              => 'FarmFacts',
      'server_recipients' => %w[ admin@localhost ],
      'server_sender'     => %w[ system@localhost ]
    }
  end

  def name
    preferences.fetch 'name'
  end
  def name=(name)
    preferences['name'] = name
  end

  def server_recipients
    preferences.fetch 'server_recipients'
  end
  def server_recipients=(*recipients)
    preferences['server_recipients'] = recipients
  end

  def server_sender
    preferences.fetch 'server_sender'
  end
  def server_sender(sender)
    preferences['server_sender'] = sender
  end

end
