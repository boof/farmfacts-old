class Theme::List < Array
  extend Shadows::Extension and attach_shadows

  class ThemeNotFound < IndexError; end

  def [](name)
    at map[name]
  end

  def installed
    select { |theme| theme.installed? }
  end

  protected
  def map() @map ||=
    Hash.new { |map, n|
      i = 0; each { |t| break if t.name == n and map[n] = i; i += 1 }
    }
  end

end
