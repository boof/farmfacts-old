class Role < ActiveRecord::Base

  extend Bulk::Destroy

  belongs_to :work, :polymorphic => true
  belongs_to :user
  validates_presence_of :user, :work_type, :work_id, :name

  named_scope :except, proc { |*ids_or_records|
    ids = ids_or_records.map { |obj| obj.is_a?(Role) ? obj.id : obj }
    { :conditions => ['roles.id NOT IN (?)', ids] }
  }
  named_scope :works_on, proc { |type, id|
    { :conditions => {:work_type => type, :work_id => id} }
  }

  def to_s
    name
  end

  def colleague_ids
    self.class.works_on(work_type, work_id).except(self).
        all(:select => :user_id).
        map! { |r| r[:user_id] }
  end

  protected
  def do_the_highlander
    self.class.works_on(work_type, work_id).except(self).
        update_all :leading => false if leading? and leading_changed?
  end
  before_save :do_the_highlander

end
