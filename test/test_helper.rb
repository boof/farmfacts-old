ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

module Builder
  class RegisteredPathBuilder
    @@counter = 0
    def self.count
      @@counter
    end
    def self.build(opts)
      attrs = opts[:only] || [:id, :label, :path]
      attrs -= opts[:except] || []

      @@counter += 1

      RegisteredPath.new do |p|
        p.id    = count if attrs.include? :id
        p.label = "Registered Path #{ count }" if attrs.include? :label
        p.path  = "target.html?count=#{ count }" if attrs.include? :path
      end
    end
  end
  class NavigationBuilder
    @@counter = 0
    def self.count
      @@counter
    end
    def self.build(opts)
      attrs = opts[:only] || [:id, :appendix, :label, :path, :locale]
      attrs -= opts[:except] || []

      @@counter += 1

      Navigation.new do |n|
        n.id        = count if attrs.include? :id
        n.appendix  = {} if attrs.include? :appendix
        n.label     = "Test Navigation #{ count }" if attrs.include? :label
        n.path      = "target.html?count=#{ count }" if attrs.include? :path
        n.locale    = 'en' if attrs.include? :locale
      end
    end
  end

  def build_navigation(opts = {})
    n = NavigationBuilder.build opts

    if block_given?
      yield n
      n.new_record? or n.destroy
    end

    n
  end

  def stub_navigation(opts = {})
    build_navigation opts do |n|
      def n.save(*args) true end
      yield n if block_given?
    end
  end

  def with_route
    route = []

    build_navigation :except => [:id] do |root|
      build_navigation :except => [:id] do |child|
        build_navigation :except => [:id] do |grand_child|
          route << root
          route[0].save

          route << child
          child.parent_id = root.id
          child.save
          root.add_child child

          route << grand_child
          grand_child.parent_id = child.id
          grand_child.save
          child.add_child grand_child

          yield route
        end
      end
    end

    route
  end

  def stub_registered_path(opts = {})
    p = RegisteredPathBuilder.build opts

    def p.save(*args) true end
    yield p if block_given?

    p
  end
end

class Test::Unit::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  #self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  #self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  #fixtures :all

  # Add more helper methods to be used by all tests here...
end
