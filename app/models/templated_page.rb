class TemplatedPage < Page

  belongs_to :template
  has_many :page_elements

end
