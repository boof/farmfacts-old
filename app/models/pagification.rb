class Pagification < ActiveRecord::Base

  belongs_to :page
  belongs_to :pagified, :polymorphic => true

  def generate_page
    build_page
    page.attributes = pagified_attributes.merge(:disposition => pagified_type)
    page.generate_path
    page.attributes = rendered_attributes
    page
  end

  protected
  def save_and_assign_page
    if page
      page.attributes = pagified_attributes
      page.attributes = rendered_attributes
    else
      generate_page
    end

    page.save and self.page_id = page.id
  end
  before_save :save_and_assign_page

  def pagified_attributes
    {
      :name     => pagified.name,
      :locale   => pagified.locale,
      :doctype  => pagified.doctype
    }
  end

  def rendered_attributes
    {
      :head     => pagified.head(page),
      :body     => pagified.body(page)
    }
  end

end
