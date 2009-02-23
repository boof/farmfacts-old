class Pagification < ActiveRecord::Base

  belongs_to :page
  belongs_to :pagified, :polymorphic => true

  def before_create
    page = Page.new :disposition => pagified_type do |p|
      p.name     = pagified.name
      p.locale   = pagified.locale
      p.doctype  = pagified.doctype
      p.head     = pagified.head
      p.body     = pagified.body
    end
    page.save

    self.page_id = page.id
  end
  def after_destroy
    page.destroy
  end

end
