class Pagification < ActiveRecord::Base

  belongs_to :page
  belongs_to :pagified, :polymorphic => true

  def generate_page
    Page.new :disposition => pagified_type do |p|
      p.name     = pagified.name
      p.locale   = pagified.locale
      p.doctype  = pagified.doctype
      p.head     = pagified.head
      p.body     = pagified.body
    end
  end
  
  def create_and_assign_page
    page = generate_page
    page.save

    self.page_id = page.id
  end
  before_create :create_and_assign_page

  def destroy_page
    page.try :destroy
  end
  def destroy_pagified
    pagified.try :destroy
  end
  after_destroy :destroy_page, :destroy_pagified

end
