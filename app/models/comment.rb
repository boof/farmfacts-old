class Comment < ActiveRecord::Base
  include ActionView::Helpers::TagHelper

  belongs_to :commented, :polymorphic => true
  validates_presence_of :author_name, :email, :body

  def hide
    self.class.transaction do
      commented.decrement! :comments_count if visible?
      update_attribute :visible, false
    end
  end
  def show
    self.class.transaction do
      commented.decrement! :comments_count unless visible?
      update_attribute :visible, true
    end
  end

  def to_s
    self[:body]
  end

  def format_body
    # Convert from CRLF or CR to LF
    self[:body].gsub! /(?:\r\n|\r)/, "\n"
    # Escape entities
    self[:body] = escape_once self[:body]
  end
  protected :format_body
  before_save :format_body

end
