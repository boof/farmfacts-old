class Comment < ActiveRecord::Base
  include ActionView::Helpers::TagHelper

  extend Bulk::Destroy
  extend Bulk::Onlist

  belongs_to :commented, :polymorphic => true
  validates_presence_of :author, :email, :message

  on_blacklist :updates => :updated_at

  def to_s
    message
  end

  protected
  def format_url
    self.url = "http://#{ url }" unless url.blank? or url =~ /^https?:\/\//
  end
  before_save :format_url

end
