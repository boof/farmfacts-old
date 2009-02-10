class Pagification

  belongs_to :page
  belongs_to :pagified, :polymorphic => true

  attr_accessor :body

  def after_save
    page || build_page(:disposition => pagified_type)
    page.save
  end
  def after_destroy
    page.destroy
  end

end
