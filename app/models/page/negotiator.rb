class Page::Negotiator

 def initialize(request, scope)
   @request, @scope = request, scope
 end

 def name
   @name ||= if @request.path != '/'
     path   = @request.path
     limit  = path.index '.', path.rindex('/')

     limit ? path[1, limit - 1] : path[1..-1]
   else
     Preferences[:FarmFacts].frontpage_name
   end
 end

 def negotiate
   @scope.find ids_by_locale[ locale ]
 end

 protected
 def ids_by_locale
  @ids_by_locale ||= @scope.named(name).
      select_all(:locale__id).
      inject({}) { |mem, (locale, id)| mem.merge locale => id }
 end
 def locale_by_path
   downcased_path = @request.path.downcase
   ext = downcased_path["/#{ name }".length..-1].to_s
   ext.gsub!(/\.html/, '')
   ext[/\.([a-z]{2})/i, 1]
 end
 def locale_by_priority
   locales_ordered_by_quality.find { |locale| ids_by_locale[locale] }
 end
 def locale
   locale_by_path || locale_by_priority ||
   Preferences[:FarmFacts].metadata['language']
 end
 def locales_ordered_by_quality
   pairs = @request.accept_language.split ','                                # ["da", " en-gb;q=0.8", " en;q=0.7"]
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
