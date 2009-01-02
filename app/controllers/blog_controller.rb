class BlogController < ApplicationController

  def index
    article_scope = Article.accepted.ordered('onlists.created_at DESC')
    title_page "#{ APPLICATION_NAME } Blog"

    respond_to do |format|
      format.html do
        article_scope = article_scope.
            dated params[:year], params[:month], params[:day]
        @article_scope = article_scope.paged 10, params[:page]

        last_modified Article.accepted.ordered.selects(:updated_at).first
      end
      format.atom do
        @articles = article_scope.paged(15, 1).all(:include => :author)
      end
    end
  end
  caches_page :index, :if => proc { |c| c.request.format.atom? }
  caches_action :index, :if => proc { |c| !c.request.format.atom? },
      :cache_path => proc { |ctrl|
        page = ctrl.params[:page].to_i
        page = 1 if page.zero?
        {:page => page}
      }

  def show
    @article  = Article.accepted.find params[:id], :include => :author
    @icon     = @article.category.icon
    @comments = @article.comments.accepted

    respond_to do |format|
      format.html do
        @comment  = @article.comments.new
        @atom = blog_path @article, :format => :atom
        title_page @article.title
        last_modified @article
      end
      format.atom
    end
  end
  caches_action :show, :if => proc { |c| c.request.format.atom? },
      :cache_path => proc { |ctrl|
        scope = Slug.article_slug ctrl.params[:id]
        {:id => scope.select_first(:sluggable_id)}
      }

end
