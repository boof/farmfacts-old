class ThemeShadow < Shadows::Base

#  def embed(locals)
#    # TODO: replace magic number vendor/themes
#    render :file => "#{ @origin.path }"[/vendor\/themes(.+)/, 1], :locals => locals
#  end
#
#  def builder(locals)
#    render :file => "#{ @origin.builder_path }"[/vendor\/themes(.+)/, 1], :locals => locals
#  end

  protected
  def _load_paths
    super + [ Theme.path.to_s ]
  end

end
