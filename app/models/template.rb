class Template < ActiveRecord::Base
  has_many :templated_pages
  serialize :definition, Hash

  def javascripts
  end
  def stylesheets
  end
  def elements
  end

end
