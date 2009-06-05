class PageShadow < Shadows::Base

  def renew
    @origin.disposition == 'Composition' ? render_composition : render_self
  end

  # obsolete

  def preview
    old_locale, I18n.locale = I18n.locale, @origin.locale

    locals = if @origin.pagification
      { :page => @origin.pagification.generate_page }
    else
      { :page => @origin }
    end

    begin
      render_shape :preview, :locals => locals
    ensure
      I18n.locale = old_locale
    end
  end



end
