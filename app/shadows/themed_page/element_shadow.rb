class ThemedPage::ElementShadow < ThemeShadow

  def icon
    @origin.icon.to_s
  end
  def form(locals = {})
    http_method, http_action = @origin.new_record??
      [:post, admin_themed_page_elements_path(@origin.themed_page)] :
      [:put, admin_themed_page_element_path(@origin.themed_page, @origin)]

    render '/form', :locals => locals, :form_opts => {
      :url => http_action,
      :html => { :method => http_method }
    }
  end
  def completed
    render_element
  end
  def sketch(locals = {})
    render_element :sketch, locals
  end

  protected
  def render_element(face = '', locals = {})
    face = "_#{ face }" unless face.blank?
    render_shape "#{ relative_element_pathname }#{ face }", :locals => locals
  end
  def relative_element_pathname
    @relative_element_pathname ||=
        @origin.pathname.relative_path_from themes_path
  end

end
