$locale = 'en'

Factory.define :page, :default_strategy => :build do |p|
  p.name    'test-page'
  p.locale  $locale
  p.doctype DocType.new(DocType::TYPES[4].last)

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

Factory.define :page_path, :class => Page::Path, :default_strategy => :build do |pp|
  pp.page { |pp| Factory.next(:page) }
  pp.page_id { |pp| pp.page.id }
end

Factory.define :navigation_with_registered_path, :default_strategy => :build, :parent => :navigation do |n|
  n.registered_path { |n| Factory.next(:registered_path_with_id) }
  n.registered_path_id { |n| n.registered_path.id }
end

Factory.define :page_component, :class => Page::Component do |pc|
  pc.template { |pc| Factory.next(:theme_template) }
  pc.template_id { |pc| pc.template.id }
  pc.composition { |pc| Factory.next(:page_composition) }
  pc.composition_id { |pc| pc.composition.id }

  pc.data { |pc| pc.template.defaults }
end

Factory.define :theme_template, :class => Theme::Template do |tt|
  tt.theme { |tt| Factory.next(:theme) }
  tt.theme_id { |tt| tt.theme.id }
end
