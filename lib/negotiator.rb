class Negotiator

  def initialize(request, defaults)
    @request, @defaults = request, defaults
  end

  def name
    @name ||= if @request.path != '/'
      path   = @request.path
      limit  = path.index '.', path.rindex('/')

      limit ? path[1, limit - 1] : path[1..-1]
    else
      @defaults[:name]
    end
  end

  def locales
    return [ locale_by_path ] unless locale_by_path.blank?
    return locales_ordered_by_quality unless locales_ordered_by_quality.blank?

    [ *@defaults[:locales] ]
  end

  def negotiate(&ids_by_locale)
    ids_by_locale.call self
  end

  protected
  def locale_by_path
    downcased_path = @request.path.downcase
    ext = downcased_path["/#{ name }".length..-1].to_s
    ext.gsub!(/\.html/, '')
    ext[/\.([a-z]{2})/i, 1]
  end
  def locales_ordered_by_quality
    pairs = "#{ @request.accept_language }".split ','                         # ["da", " en-gb;q=0.8", " en;q=0.7"]
    pairs.map! do |pair|                                                      # [["da", 1.0], ["en-gb", 0.8], ["en", 0.7]]
      lang, q = pair.split(';').first 2

      lang.strip!
      q = q ? q[2, 3].to_f : 1.0

      [ lang, q ]
    end
=begin
    pairs.sort! { |x, y| -1 * ( x.last <=> y.last ) }                         # [["da", 1.0], ["en-gb", 0.8], ["en", 0.7]]
=end
    pairs.map! { |pair| pair.first }                                          # ["da", "en-gb", "en"]
  end

end
