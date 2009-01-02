class Admin::CommentsController < Admin::Base

  cache_sweeper :comment_sweeper

  def bulk
    Comment.bulk_methods.include? params[:bulk_action] and
    current_user.will params[:bulk_action], Comment,
      params[:comment_ids], params

    redirect_to params[:return_to]
  end

  protected
  class CommentPolymorphism < Polymorphism; set_namespace :admin end
  def assign_polymorphism
    @polymorphism = CommentPolymorphism.new self
  end
  before_filter :assign_polymorphism

end
