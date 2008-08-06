class CommentsController < ApplicationController

  caches_page :list
  cache_sweeper :page_sweeper, :only => :create
  cache_sweeper :article_sweeper, :only => :create
  cache_sweeper :comment_sweeper, :only => :create

  self.allow_forgery_protection = true

  verify :xhr => true
  def list
    @comments = Comment.find :all, :order => 'created_at DESC',
      :offset => params[:offset].to_i * 10, :limit => 10,
      :conditions => {
        :commented_id   => params[:id],
        :commented_type => params[:type],
        :visible        => true
      }
  end

  def new
    @comment = Comment.new do |c|
      c.commented_id    = params[:commented_id]
      c.commented_type  = params[:commented_type]
    end
  end

  def create
    @comment = Comment.new do |c|
      c.commented_id    = params[:commented_id]
      c.commented_type  = params[:commented_type]
    end
    @comment.attributes = params[:comment]

    if @comment.save
      render(:update) { |page| page.redirect_to params[:referer] }
    else
      render :action => :new
    end
  end

end
