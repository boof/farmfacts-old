class PageShadow < Shadows::Base
  def preview
    locals = if @origin.pagification
      { :page => @origin.pagification.generate_page }
    else
      { :page => @origin }
    end
    old_locale, I18n.locale = I18n.locale, @origin.locale

    begin
      render_shape :preview, :locals => locals
    ensure
      I18n.locale = old_locale
    end
  end
end
