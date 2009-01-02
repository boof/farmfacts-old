module Gravatar

  def self.included(base)
    base.extend ClassAttribute
    base.instance_variable_set :@gravatar, API.new
  end

  module ClassAttribute
    attr_reader :gravatar
  end

  def gravatar_url(options = {})
    self.class.gravatar.url_for self, options
  end

  class API
    HOST, PATH_ = 'gravatar.com', 'avatar'
    VALID_OPTIONS = [:secure, :rating, :size, :default]

    attr :defaults
    attr_accessor :email_extractor

    def initialize
      @defaults, @email_extractor = {}, proc { |source| source.email }
    end

    def url_for(source, options = {})
      options = sanitize_options options

      "#{ scheme options.delete(:secure) }://#{ HOST }/" +
      "#{ PATH_ }/#{ id source }.png#{ query options }"
    end

    protected
    def sanitize_options(options)
      defaults.merge(options).reject { |k, v| not VALID_OPTIONS.include? k }
    end
    def scheme(secure = false)
      "http#{ 's' if secure }"
    end
    def id(source)
      Digest::MD5.hexdigest "#{ email_extractor.call source }".downcase
    end
    def query(options)
      return if options.blank?
      '?' << options.map { |k, v| "#{ k }=#{ CGI.escape v.to_s }" } * '&'
    end
  end

end
