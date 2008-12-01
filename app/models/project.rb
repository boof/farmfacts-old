class Project < ActiveRecord::Base

  has_many :project_roles

  validates_uniqueness_of :name
  validates_presence_of :name, :description

end
