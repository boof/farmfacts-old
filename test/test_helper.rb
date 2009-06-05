ENV['RAILS_ENV'] = 'test'

require File.expand_path("#{ File.dirname __FILE__ }/../config/environment")
require 'test_help'

class Test::Unit::TestCase
  include RR::Adapters::TestUnit

  def initialize_controller(controller_class = ActionController::Base)
    controller = controller_class.new
    controller.request  = ActionController::TestRequest.new
    controller.response = ActionController::TestResponse.new
    controller.params   = {}
    controller.send :initialize_current_url

    controller
  end

  def build_navigation(attrs = {})
    n = Factory.next(:navigation)
    attrs.each { |a, v| n[a] = v }

    if block_given?
      yield n
      n.new_record? or n.destroy
    end

    n
  end

  def build_navigation_with_registered_path(attrs = {})
    n = Factory(:navigation_with_registered_path, attrs)

    stub(n.registered_path).new_record? { false }
    stub(n.registered_path).save { true }

    if block_given?
      yield n
      n.new_record? or n.destroy
    end

    n
  end

  def with_route
    route = []

    build_navigation do |root|
      build_navigation do |child|
        build_navigation do |grand_child|
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

end
