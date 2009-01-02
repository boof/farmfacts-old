class CommentsController < ApplicationController

  cache_sweeper :comment_sweeper

  class ReplyPolymorphism < Polymorphism; set_polymorph :comment end
  def assign_polymorphism
    @polymorphism = ReplyPolymorphism.new self
  end
  before_filter :assign_polymorphism

  def create
    title_page "#{ @polymorphism.proxy_owner }"
    @comment = @polymorphism.proxy.new params[:comment]
    redirect_to params[:return_to] || root_path if @comment.save
  end

end
