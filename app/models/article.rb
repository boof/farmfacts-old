class Article < ActiveRecord::Base

  extend Bulk::Destroy
  extend Bulk::Onlist

  belongs_to :author, :class_name => 'User'
  belongs_to :category, :class_name => 'Categorizable::Category'
  has_many :comments, :as => :commented, :dependent => :delete_all
  has_many :attachments, :as => :attaching, :dependent => :delete_all

  validates_presence_of :title, :body

  has_friendly_id :title, :use_slug => true, :strip_diacritics => true
  registers_path { |article| "/blog/#{ article.to_param }" }
  onlist :updates => :updated_at
  categorizable

  def self.offset(article_id)
    find(:all, :select => 'articles.id').map! {|r|r.id}.index(article_id) || 0
  end

  named_scope :ordered, proc { |*columns|
    columns << 'articles.updated_at DESC' if columns.empty?

    { :order => columns * ', ' }
  }
  named_scope :paged, proc { |limit, page|
    page = page.to_i
    page = 1 if page.zero?

    { :limit => limit, :offset => limit * (page - 1) }
  }
  named_scope :dated, proc { |year, month, day|
    unless year then {}
    else
      lower = Time.local year, month, day
      upper = if day then   lower + (1.day - 1)
          elsif month then  lower + (1.month - 1)
          else              lower + (1.year - 1)
          end

      { :conditions =>
          [ 'articles.created_at BETWEEN ? AND ?', lower, upper ] }
    end
  }

  # implement attachments
  def announcement
    plain = RedCloth.new(body, [:filter_html, :filter_styles, :filter_classes, :filter_ids]).to_markdown :syntax2pre
    html = RedCloth.new(body, [:filter_styles, :filter_classes, :filter_ids]).to_html :textile, :syntax_hi
    Announcement.new :plain => plain, :html => html, :subject => title, :sender => author.email
  end

  def to_s
    title
  end

  def category_names=(names)
    @category_name = category_name_divider.split("#{ names }").first
    super
  end

  protected
  def set_category
    if @category_name && !category
      self.category = categories.proxy_target.find { |category|
          category.name == @category_name }
    end
  end
  def add_category_to_categories
    if category_id
      categories.proxy_target.any? { |category| category.id == category_id } or
      categories << category
    end
  end
  before_save :set_category, :add_category_to_categories, :if => proc { |r| r.categories.loaded? }

end
