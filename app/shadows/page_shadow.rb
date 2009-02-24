class PageShadow < Shadows::Base
  def preview
    locals = if @origin.pagification
      { :page => @origin.pagification.generate_page }
    else
      { :page => @origin }
    end

    render_shape :preview, :locals => locals
  end
end
