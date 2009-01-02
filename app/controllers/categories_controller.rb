class CategoriesController < ApplicationController

  def index
    @categories = Categorizable::Category.selects(:id, :name, :slug).find :all,
        :include => :categorizations,
        :order => 'categorizable_categories.name'
    @categories.delete_if { |c| c.categorizations.empty? }

    @categorization_count = Categorizable::Categorization.count

    title_page 'Categories'
    last_modified Categorizable::Categorization.selects(:updated_at).
        first(:order => 'updated_at DESC')
  end
  caches_page :index

  def show
    @category         = Categorizable::Category.rejects(:timestamps).find params[:id]
    @icon             = @category.icon
    @page_paths_and_titles = Page.related_to(@category).accepted.select_all(:path__title, :order => :title)
    @articles         = Article.related_to(@category).accepted.selects(:id, :title).all(:order => :title)
    @projects         = Project.related_to(@category).all(:order => :name)

    title_page "Related to #{ @category }"
    last_modified @category.categorizations.selects(:updated_at).
        first(:order => 'updated_at DESC')
  end
  caches_action :show

end
