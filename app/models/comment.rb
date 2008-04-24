class Comment < ActiveRecord::Base
  
  belongs_to :commented, :polymorphic => true
  
  def hide
    update_attribute :visible, false
  end
  def show
    update_attribute :visible, true
  end
  
end
