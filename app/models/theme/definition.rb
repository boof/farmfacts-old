class Theme::Definition

  attr_reader :attachments

  def self.load(path)
    new YAML.load_file(path)
  end

  def initialize(definition)
    @definition = definition

    initialize_attachments
  end

  protected
  def initialize_attachments
    @attachments = @definition.fetch 'attachments', {}
    @attachments.extend Attachments
  end

  module Attachments
    def build(path)
      attributes = fetch path.to_s, {}
      attributes.update :attachable => path.open

      Attachment.new attributes
    end
  end

end
