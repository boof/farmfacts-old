class Admin::PreviewsController < Admin::Base

  verify :xhr => true

  def render_markdown
    maruku = Maruku.new params[:markdown]
    render :text => maruku.to_html
  end

end
