require 'test_helper'

class PageTest < ActiveSupport::TestCase

  def setup
    Shadows.controller = initialize_controller
  end
  def teardown
    Shadows.controller = nil
  end

  def test_page_has_finder
    assert Page::Finder === Page
  end

  def test_page_has_bulk_methods_for_destroy
    assert Bulk::Destroy === Page
  end

  def test_page_has_bulk_methods_for_onlist
    assert Bulk::Onlist === Page
  end

=begin
  def test_page_generates_html
    expected_html = <<-HTML
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns='http://www.w3.org/1999/xhtml'>
  <head><title>Test Page</title></head>
  <body><h1>Test Page</h1></body>
</html>
HTML

    assert_equal expected_html, Factory(:page).to_html
  end

  def test_page_renews_itself_if_flagged
    page = Factory(:page, :renew => true)
    stub(page).to_s(:renew)

    page.to_html
    assert_received(page) { |got| got.to_s(:renew) }
  end

  def test_page_expires
    page = Factory(:page)
    stub(page).update_attribute(:renew, true)

    page.expire
    assert_received(page) { |got| got.update_attribute(:renew, true) }
  end
=end

end
