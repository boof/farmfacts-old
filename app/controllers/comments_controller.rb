class CommentsController < ApplicationController
  
  cache_sweeper :page_sweeper, :only => :create
  cache_sweeper :article_sweeper, :only => :create
  cache_sweeper :comment_sweeper, :only => :create
  
  caches_page :list
  
  def list
    respond_to do |wants|
      wants.html  { render :nothing => true, :status => 400 }
      wants.js    do
        @comments = Comment.find :all, :order => 'created_at DESC',
          :offset => params[:offset].to_i * 10, :limit => 10,
          :conditions => {
            :commented_id   => params[:id],
            :commented_type => params[:type],
            :visible        => true
          }
      end
    end
  end
  
  def new
    respond_to do |wants|
      wants.html  { render :nothing => true, :status => 400 }
      wants.js    do
        @comment = Comment.new do |c|
          c.commented_id    = params[:commented_id]
          c.commented_type  = params[:commented_type]
        end
      end
    end
  end
  
  def create
    respond_to do |wants|
      wants.html  { render :nothing => true, :status => 400 }
      wants.js    do
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
  end
  
end
