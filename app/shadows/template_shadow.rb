class TemplateShadow < Shadows::Base
  def embed(locals)
    render :file => "#{ @origin.path }"[/vendor\/templates(.+)/, 1], :locals => locals
  rescue
    Rails.logger.error $!
  end

  protected
  def _load_paths
    super + [::Template.path.to_s]
  end

end
