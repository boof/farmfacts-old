require 'test_helper'

class PageCompositionTest < ActiveSupport::TestCase

  def setup
    Shadows.controller = initialize_controller
  end
  def teardown
    Shadows.controller = nil
  end

=begin
  def test_composition_generates_page
    Factory(:page_composition)
  end
=end

end
