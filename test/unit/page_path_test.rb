require 'test_helper'

class PagePathTest < ActiveRecord::TestCase

  def before_save_callbacks(klass)
    klass.before_save_callback_chain.map { |cb| cb.method }
  end
  def assert_before_save(object, method)
    assert before_save_callbacks(object.class).include?(method)
  end

  def test_before_save_name_reads_from_page
    test_method, page_path = :name_reads_from_page, Factory(:page_path)
    assert_before_save(page_path, test_method)

    page_path.send test_method
    assert_equal page_path.page.name, page_path.name
  end
  def test_before_save_locale_reads_from_page
    test_method, page_path = :locale_reads_from_page, Factory(:page_path)
    assert_before_save(page_path, test_method)

    page_path.send test_method
    assert_equal page_path.page.locale, page_path.locale
  end

  def test_before_save_path_generates_from_name_and_locale
    test_method, page_path = :name_and_locale_generate_path, Factory(:page_path)
    assert_before_save(page_path, test_method)

    page_path.attributes = {:name => 'test', :locale => 'en'}
    page_path.send test_method
    assert_equal 'test.en', page_path.path
  end

  def test_path_finds_all_by_request_path_without_limited_locales
    path = '/test'
    assert_equal [], Page::Path.find_all_by_request_path(path)
  end

end
