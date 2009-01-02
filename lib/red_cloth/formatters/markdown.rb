module RedCloth::Formatters::Markdown
  include RedCloth::Formatters::Base
  
  # escapement for regular HTML (not in PRE tag)
  def escape(text)
    html_esc(text)
  end

  # escapement for HTML in a PRE tag
  def escape_pre(text)
    html_esc(text, :html_escape_preformatted)
  end
  
  # escaping for HTML attributes
  def escape_attribute(text)
    html_esc(text, :html_escape_attributes)
  end
  
  def after_transform(text)
    text.gsub!(/<\/?pre>/, "\n")
    text.chomp!
  end
    
  def p(opts)
    "#{ opts[:text] }\n\n"
  end
  def h1(opts)
    "#{ opts[:text] }#{ '=' * opts[:text].to_s.size }"
  end
  def h2(opts)
    "#{ opts[:text] }#{ '-' * opts[:text].to_s.size }"
  end
  ( 3..6 ).each do |i|
    define_method(:"h#{ i }") { "#{ '#' * i } #{ opts[:text] }" }
  end

  [:pre, :div].each do |m|
    define_method(m) do |opts|
      "<#{m}#{pba(opts)}>#{opts[:text]}</#{m}>\n"
    end
  end
  
  def strong(opts)
    opts[:block] = true
    "**#{ opts[:text] }**"
  end
  def em(opts)
    opts[:block] = true
    "*#{ opts[:text] }*"
  end

  [:code, :i, :b, :ins, :sup, :sub, :span, :cite].each do |m|
    define_method(m) do |opts|
      opts[:block] = true
      "<#{m}#{pba(opts)}>#{opts[:text]}</#{m}>"
    end
  end
  
  def hr(opts)
    '- - -'
  end
  
  def acronym(opts)
    opts[:block] = true
    "<acronym#{pba(opts)}>#{caps(:text => opts[:text])}</acronym>"
  end
  
  def caps(opts)
    opts[:text]
  end
  
  def del(opts)
    opts[:block] = true
    "<del#{pba(opts)}>#{opts[:text]}</del>"
  end
  
  [:ol, :ul].each do |m|
    define_method("#{m}_open") do |opts|
      "\n"
    end
    define_method("#{m}_close") do |opts|
      "\n"
    end
  end
  
  def li_open(opts)
    "#{ "  " * (opts[:nest] - 1) }* #{ pba(opts) }#{ opts[:text] }"
  end
  
  def li_close(opts=nil)
    "\n"
  end
  
  def dl_open(opts)
    opts[:block] = true
    "<dl#{pba(opts)}>\n"
  end
  
  def dl_close(opts=nil)
    "</dl>\n"
  end
  
  [:dt, :dd].each do |m|
    define_method(m) do |opts|
      "\t<#{m}#{pba(opts)}>#{opts[:text]}</#{m}>\n"
    end
  end
  
  def td(opts)
    tdtype = opts[:th] ? 'th' : 'td'
    "\t\t<#{tdtype}#{pba(opts)}>#{opts[:text]}</#{tdtype}>\n"
  end
  
  def tr_open(opts)
    "\t<tr#{pba(opts)}>\n"
  end
  
  def tr_close(opts)
    "\t</tr>\n"
  end
  
  def table_open(opts)
    "<table#{pba(opts)}>\n"
  end
  
  def table_close(opts)
    "</table>\n"
  end
  
  def bc_open(opts)
    opts[:block] = true
    "<pre#{pba(opts)}>"
  end
  
  def bc_close(opts)
    "</pre>\n"
  end
  
  def bq_open(opts)
    opts[:block] = true
    cite = opts[:cite] ? " cite=\"#{ escape_attribute opts[:cite] }\"" : ''
    "\n"
  end
  
  def bq_close(opts)
    "\n"
  end
  
  LINK_TEXT_WITH_TITLE_RE = /
          ([^"]+?)         # $text
          \s?
          \(([^)]+?)\)     # $title
          $
      /x
  def link(opts)
    if opts[:name] =~ LINK_TEXT_WITH_TITLE_RE
      md = LINK_TEXT_WITH_TITLE_RE.match(opts[:name])
      opts[:name] = md[1]
      opts[:title] = md[2]
    end
    %Q'[#{ opts[:name ] }](#{ escape_attribute opts[:href] }#{ " #{ opts[:title] }" if opts[:title] })'
  end
  
  def image(opts)
    opts.delete(:align)
    opts[:alt] = opts[:title]
    %Q'![#{ opts[:alt] }](#{ opts[:src ]} "#{opts[:title]}") #{ " <#{ opts[:href] if opts[:href] }>"}'
  end
  
  def footno(opts)
    opts[:id] ||= opts[:text]
    %Q{<sup class="footnote"><a href=\"#fn#{opts[:id]}\">#{opts[:text]}</a></sup>}
  end
  
  def fn(opts)
    no = opts[:id]
    opts[:id] = "fn#{no}"
    opts[:class] = ["footnote", opts[:class]].compact.join(" ")
    "<p#{pba(opts)}><sup>#{no}</sup> #{opts[:text]}</p>\n"
  end
  
  def snip(opts)
    "`#{ opts[:text] }`"
  end
  
  def quote1(opts)
    "'#{ opts[:text] }'"
  end
  
  def quote2(opts)
    %Q'"#{ opts[:text] }"'
  end
  
  def multi_paragraph_quote(opts)
    %Q'"#{ opts[:text] }'
  end
  
  def ellipsis(opts)
    "#{ opts[:text] }..."
  end
  
  [:emdash, :endash].each { |m| define_method(m) { |opts| ' - ' } }
  
  def arrow(opts)
    "&#8594;"
  end
  
  def dim(opts)
    opts[:text]
  end
  
  def trademark(opts)
    "(tm)"
  end
  
  def registered(opts)
    "(r)"
  end
  
  def copyright(opts)
    "(c)"
  end
  
  def entity(opts)
    opts[:text]
  end
  
  def amp(opts)
    "&"
  end
  
  def gt(opts)
    ">"
  end
  
  def lt(opts)
    "<"
  end
  
  def br(opts)
    "\n"
  end
  
  def quot(opts)
    '"'
  end
  
  def squot(opts)
    "'"
  end
  
  def apos(opts)
    "'"
  end
  
  def html(opts)
    "#{ opts[:text] }\n"
  end
  
  def html_block(opts)
    inline_html(:text => "#{opts[:indent_before_start]}#{opts[:start_tag]}#{opts[:indent_after_start]}") + 
    "#{opts[:text]}" +
    inline_html(:text => "#{opts[:indent_before_end]}#{opts[:end_tag]}#{opts[:indent_after_end]}")
  end
  
  def notextile(opts)
    if filter_html
      html_esc(opts[:text], :html_escape_preformatted)
    else
      opts[:text]
    end
  end
  
  def inline_html(opts)
    if filter_html
      html_esc(opts[:text], :html_escape_preformatted)
    else
      "#{opts[:text]}" # nil-safe
    end
  end
  
  def ignored_line(opts)
    "#{ opts[:text] }\n"
  end
  
  def before_transform(text)
    clean_html(text) if sanitize_html
  end
  
  # HTML cleansing stuff
  BASIC_TAGS = {
      'a' => ['href', 'title'],
      'img' => ['src', 'alt', 'title'],
      'br' => [],
      'i' => nil,
      'u' => nil, 
      'b' => nil,
      'pre' => nil,
      'kbd' => nil,
      'code' => ['lang'],
      'cite' => nil,
      'strong' => nil,
      'em' => nil,
      'ins' => nil,
      'sup' => nil,
      'sub' => nil,
      'del' => nil,
      'table' => nil,
      'tr' => nil,
      'td' => ['colspan', 'rowspan'],
      'th' => nil,
      'ol' => ['start'],
      'ul' => nil,
      'li' => nil,
      'p' => nil,
      'h1' => nil,
      'h2' => nil,
      'h3' => nil,
      'h4' => nil,
      'h5' => nil,
      'h6' => nil, 
      'blockquote' => ['cite'],
      'notextile' => nil
  }
  
  # Clean unauthorized tags.
  def clean_html( text, allowed_tags = BASIC_TAGS )
    text.gsub!( /<!\[CDATA\[/, '' )
    text.gsub!( /<(\/*)([A-Za-z]\w*)([^>]*?)(\s?\/?)>/ ) do |m|
      raw = $~
      tag = raw[2].downcase
      if allowed_tags.has_key? tag
        pcs = [tag]
        allowed_tags[tag].each do |prop|
          ['"', "'", ''].each do |q|
            q2 = ( q != '' ? q : '\s' )
            if raw[3] =~ /#{prop}\s*=\s*#{q}([^#{q2}]+)#{q}/i
              attrv = $1
              next if (prop == 'src' or prop == 'href') and not attrv =~ %r{^(http|https|ftp):}
              pcs << "#{prop}=\"#{attrv.gsub('"', '\\"')}\""
              break
            end
          end
        end if allowed_tags[tag]
        "<#{raw[1]}#{pcs.join " "}#{raw[4]}>"
      else # Unauthorized tag
        if block_given?
          yield m
        else
          ''
        end
      end
    end
  end
end
