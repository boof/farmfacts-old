class Publication < ActiveRecord::Base
  
  belongs_to :publishable, :polymorphic => true
  belongs_to :editor, :class_name => 'User'
  
  def revoke(editor)
    update_attributes :revoked => true, :user_id => editor.id
  end
  def provoke(editor)
    update_attributes :revoked => false, :user_id => editor.id
  end
  
  def to_s
    "of #{ self[:publishable_type] } #{ self[:publishable_id] }"
  end
  
end
