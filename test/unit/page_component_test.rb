require 'test_helper'

class PageComponentTest < ActiveSupport::TestCase

  def setup
    Shadows.controller = initialize_controller
  end
  def teardown
    Shadows.controller = nil
  end

=begin
  def test_component_renders_template
    component = Factory(:page_component)
    stub(component.template).to_s :component, component

    component.to_s
    assert_receive(component) { |spy| spy.to_s :component, component }
  end
=end

end
