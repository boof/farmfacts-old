class Admin::CategoriesController < Admin::Base

  def index
    @categorizations_count  = Categorizable::Categorization.count
    @categories             = Categorizable::Category.find :all,
        :include => :categorizations,
        :order => :name

     current.title = translate :categories
  end

  def show
    @categorizations = @category.categorizations.find :all,
        :include => :categorizable,
        :order => 'categorizable_type, categorizable_id'

    current.title = "#{ translate :category }: #{ @category.name }"
  end

  def new
    current.title = "#{ translate :new } #{ translate :category }"
  end
  def edit
    current.title = "#{ translate :edit } #{ translate :category }: #{ @category.name }"
  end

  def create
    save_or_render :new, :category do |category|
      return_or_redirect_to admin_category_path(category.id)
    end
  end
  def update
    save_or_render :edit, :category, admin_category_path(@category.id)
  end

  def bulk
    Categorizable::Category.bulk_methods.include? params[:bulk_action] and
    Categorizable::Category.send params[:bulk_action], params[:category_ids], params

    return_or_redirect_to admin_categories_path
  end

  protected
  def assign_new_category
    @category = Categorizable::Category.new
  end
  before_filter :assign_new_category, :only => [:new, :create]
  def assign_category_by_id
    @category = Categorizable::Category.find params[:id]
  end
  before_filter :assign_category_by_id, :only => [:show, :edit, :update]

end
