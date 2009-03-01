class Pagification < ActiveRecord::Base

  belongs_to :page
  belongs_to :pagified, :polymorphic => true

  def generate_page
    build_page
    page.attributes = pagified_attributes.merge(:disposition => pagified_type)
    page
  end

  protected
  def save_and_assign_page
    success = if page
      page.update_attributes pagified_attributes
    else
      generate_page.save
    end

    success and self.page_id = page.id
  end
  before_save :save_and_assign_page

  def pagified_attributes
    {
      :name     => pagified.name,
      :locale   => pagified.locale,
      :doctype  => pagified.doctype,
      :head     => pagified.head(page),
      :body     => pagified.body(page)
    }
  end

end
