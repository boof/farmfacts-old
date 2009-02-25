module Pagificator

  def self.included(base)
    base.has_one :pagification, :as => :pagified, :dependent => :destroy
    base.has_one :page, :through => :pagification

    base.has_many :attachments, :as => :attaching, :dependent => :destroy
    base.delegate :javascripts, :stylesheets, :images, :to => :attachments

    base.serialize :metadata, Hash
    base.composed_of :metatags, :class_name => 'Pagification::Metatags',
      :mapping => %w[ metadata ],
      :converter => proc { |data| Metatags.new data }

    base.after_save :pagify
  end

  def pagify
    pagification ?
      pagification.save_without_dirty :
      build_pagification(:pagified => self).save
  end

end
