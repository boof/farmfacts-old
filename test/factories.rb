$locale = 'en'

Factory.define :page, :default_strategy => :build do |p|
  p.name    'test-page'
  p.locale  $locale
  p.doctype DOC_TYPES[4].last

  p.head <<-HEAD
<title>Test Page</title>
HEAD

  p.body <<-BODY
<h1>Test Page</h1>
BODY

end
Factory.sequence(:page) { |n| Factory :page, :name => "test-page-#{n}" }


Factory.define :registered_path, :default_strategy => :build do |rp|
  rp.label  'Test Registered Path'
  rp.scope  $locale

  rp.path   { |rp| rp.label ? "#{ rp.label.parameterize }.#{ rp.scope }" : nil }
end
Factory.sequence :registered_path_with_id do |n|
  rp = Factory :registered_path, :label => "Test Registered Path #{n}"
  rp.id = n

  rp
end


Factory.define :navigation, :default_strategy => :build do |n|
  n.appendix  Hash.new
  n.label     'Test Navigation'
  n.locale    $locale
  n.path      { |n| n.label ? "#{ n.label.parameterize }.#{ n.locale }" : nil }
end
Factory.sequence :navigation do |n|
  Factory :navigation, :label  => "Test Navigation #{n}"
end

Factory.define :navigation_with_registered_path, :default_strategy => :build, :parent => :navigation do |n|
  n.registered_path { |n| Factory.next(:registered_path_with_id) }
  n.registered_path_id { |n| n.registered_path.id }
end
