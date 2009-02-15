module Admin::BaseHelper
  def registered_paths_options(node)
    groups = Hash.new { |h, k| h[k] = [] }
    for path in node.registered_paths.all(:order => :path)
      groups[path.provider_type] << path
    end

    output = '<option></option>'
    for name in groups.keys.sort
      output << %Q'<optgroup label="#{ name.demodulize.humanize }">'
      for path in groups[name]
        output << if node.registered_path != path
            %Q'<option value="#{ path.id }">#{ path.label }</option>'
          else
            %Q'<option value="#{ path.id }" selected="selected">#{ path.label }</option>'
          end
      end
      output << %Q'</optgroup>'
    end
    output
  end
  def render_metadata_form(data, scope, title = 'Meta Information')
    render 'admin/shared/metadata',
      :object => data, :scope => scope, :title => title
  end

end
