class PageElement < ActiveRecord::Base
  acts_as_list :scope => :templated_page

  belongs_to :templated_page
  serialize :data, Hash
end