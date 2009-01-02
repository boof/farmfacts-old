require 'rubygems'
require 'active_support/memoizable'
require 'httparty'

module GitHub
  class User
    extend ActiveSupport::Memoizable

    attr_reader :name

    include HTTParty
    base_uri 'github.com/api/v1/json'
    format :json

    def initialize(name)
      @name = name
    end

    def repositories
      repositories_hash, idx = {}, 0
      while attrs = data['repositories'].at(idx)
        repository = Repository.new self, attrs
        repositories_hash[ repository.name ], idx = repository, idx + 1
      end
      repositories_hash
    end
    memoize :repositories

    def repository_names
      repositories.keys
    end

    def company
      data['company']
    end
    def location
      data['location']
    end
    def login
      data['login']
    end
    def email
      data['email']
    end

    alias_method :to_s, :name
    alias_method :inspect, :name

    protected
    def data
      data = self.class.get "/#{ self }"
      data.fetch 'user'
    end
    memoize :data
  end

  class Repository
    extend ActiveSupport::Memoizable

    attr_reader :owner, :name, :watchers, :url, :description
    attr_accessor :branch

    include HTTParty
    base_uri 'github.com/api/v1/json'
    format :json

    def self.build(path)
      username, repository = path.split '/'
      user = User.new username
      user.repositories.fetch repository
    end

    def initialize(user, attrs)
      @owner = user

      @name         = attrs['name']
      @private      = attrs['private']
      @watchers     = attrs['watchers']
      @fork         = attrs['fork']
      @url          = attrs['url']
      @forks        = attrs['forks']
      @description  = attrs['description']

      self['master']
    end

    def fork?
      @fork
    end
    def forked?
      @forks > 0
    end
    def watched?
      @watchers > 1
    end

    def commits
      array, idx = [], 0
      while attrs = data.at(idx)
        array[ idx ], idx = Commit.new(self, attrs), idx + 1
      end
      array
    end
    memoize :commits

    def commits_hash
      hash, idx = {}, 0
      while commit = commits.at(idx)
        hash[ commit.id ], idx = commit, idx + 1
      end
      hash
    end
    memoize :commits_hash

    def commit(id)
      commits_hash.fetch id
    end
    def [](branch)
      self.branch = branch
      self
    end

    def commit_ids
      commits_hash.keys
    end

    alias_method :to_s, :name

    def inspect
      "#{ self }: #{ description } (#{ url })"
    end

    protected
    def data
      data = self.class.get "/#{ owner }/#{ self }/commits/#{ branch }"
      data.fetch 'commits'
    end
    memoize :data

  end

  class Commit
    extend ActiveSupport::Memoizable
    attr_reader :repository
    attr_reader :id, :parent_ids, :message, :url,
        :author, :authored_at,
        :committer, :committed_at

    class << self
      extend ActiveSupport::Memoizable
      memoize :new
    end

    include HTTParty
    base_uri 'github.com/api/v1/json'
    format :json

    def initialize(repository, attrs)
      @repository = repository

      @id           = attrs['id']
      @parent_ids   = attrs['parents'].map { |p_hash| p_hash['id'] }
      @message      = attrs['message']
      @url          = attrs['url']
      @author       = attrs['author']
      @authored_at  = attrs['authored_date']
      @committer    = attrs['committer']
      @committed_at = attrs['committed_date']
    end

    def parents
      @parent_ids.map { |parent_id| repository.commit parent_id }
    end

    def added
      data['added']
    end
    def modified
      data['modified']
    end
    def removed
      data['removed']
    end

    def to_s
      message.split("\n").first
    end

    def inspect
      "[#{ id }] #{ self } (#{ url })"
    end

    protected
    def data
      data = self.class.
          get "/#{ repository.owner }/#{ repository }/commit/#{ id }"

      data.fetch 'commit'
    end
    memoize :data

  end
end

__END__
require 'git_hub'
fork = GitHub::User.new 'fork'
fork.repository_names.each { |n| puts n }
onlist = fork.repositories.fetch 'onlist'
onlist.commits.each { |c| puts c }
