require 'test_helper'

class NavigationTest < ActiveSupport::TestCase
  include Builder

  def test_route_returns_an_array_of_navigations
    with_route do |route|
      assert_equal route, route.last.route
    end
  end
  def test_route_to_path_returns_an_array_of_navigations
    with_route do |route|
      assert_equal route, route.first.route_to_path(route.last.path)
    end
  end

  # before save callbacks
  def test_that_path_is_completed_from_registered_path_on_save
    build_navigation :except => [:path] do |navigation|
      stub_registered_path do |p|
        navigation.registered_path_id = p.id
        navigation.registered_path = p
      end
      navigation.save

      assert_equal navigation.path, "target.html?count=#{ Builder::RegisteredPathBuilder.count }"
    end
  end
  def test_that_label_is_completed_from_registered_path_on_save
    build_navigation :except => [:label] do |navigation|
      stub_registered_path do |p|
        navigation.registered_path_id = p.id
        navigation.registered_path = p
      end
      navigation.save

      assert_equal navigation.label, "Registered Path #{ Builder::RegisteredPathBuilder.count }"
    end
  end
  def test_that_locale_is_completed_from_parent_on_save
    build_navigation :except => [:locale] do |navigation|
      stub_registered_path do |p|
        navigation.registered_path_id = p.id
        navigation.registered_path = p
      end
      stub_navigation do |parent|
        navigation.parent_id = parent.id
        navigation.parent = parent
      end
      navigation.save

      assert_equal navigation.locale, 'en'
    end
  end
  def test_that_locale_is_completed_from_registered_path_on_save
    build_navigation :except => [:locale] do |navigation|
      stub_registered_path do |p|
        p.scope = 'en'
        navigation.registered_path_id = p.id
        navigation.registered_path = p
      end
      navigation.save

      assert_equal navigation.locale, 'en'
    end
  end

end
