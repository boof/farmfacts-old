require 'test_helper'

class ThemeTest < ActiveSupport::TestCase

  def setup
    Shadows.controller = initialize_controller
  end
  def teardown
    Shadows.controller = nil
  end

  def test_theme_can_render_pages
  end

end
