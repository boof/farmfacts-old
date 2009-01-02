# /attachments/articles/1/polymorphism.rb?1229370224
# @:articles/1/polymorphism.rb
# p(attachment). %{float: left; height: 2.4em; margin-right: 1em;}!/images/icons/icon_download.gif!:/attachments/articles/1/polymorphism.rb% "polymorphism.rb":/attachments/articles/1/polymorphism.rb
#   File Size: '%.2f KB'

module RedCloth
  NOTEXTILE = '<notextile>%s</notextile>'.freeze

  # Provide attachments using <<'a:articles/1/something.bin'
  module Attachment
    ATTACHMENT_TAG_RX = /([\s])?<<'a\:([^']+)'/
    ATTACHMENT_SUB    = %Q'%sp(attachment). %%{float: left; height: 2.4em; margin-right: 1em;}!/images/icons/icon_download.gif!:%s%% "%s":%s\n  File Size: %.1f %s'

    def attachment(text)
      text.gsub! ATTACHMENT_TAG_RX do |m|
        whitespace_pre  = $~[1]
        path, basename = "/attachments/#{ $~[2] }", File.basename($~[1])
        size = File.size File.join(Rails.root, 'public', path)
        size, units = if (1.kilobyte ... 1.megabyte).include? size
          [size.to_f / 1.kilobyte, 'KB']
        elsif (1.megabyte ... 1.gigabyte).include? size
          [size.to_f / 1.megabyte, 'MB']
        else
          [size, 'bytes']
        end
        ATTACHMENT_SUB % [whitespace_pre, path, basename, path, size, units]
      end
    end
  end
  include Attachment

  module CodeRay
    SOURCE_TAG_RX = /(([\t\n])?<source(?:\:([a-z]+))?>(.+?)<\/source>[\t\n]?)/m

    def syntax2pre(text)
      text.gsub! SOURCE_TAG_RX do |m|
        whitespace_pre = $~[2]
        code = $~[4].split("\n").each { |line| line.insert(0, '    ').chomp! } * "\n"
        code = "<pre>#{ code }\n</pre>"

        "#{ whitespace_pre }#{ NOTEXTILE % code }"
      end
    end

    def syntax_hi(text)
      text.gsub! SOURCE_TAG_RX do |m|
        fragment        = $~[1]
        whitespace_pre  = $~[2]
        language        = ($~[3] || :ruby).to_sym
        code            = $~[4]
        code.strip!

        hi_code = ::CodeRay.scan(code, language).
            div :css => :class, :line_numbers => :list, :bold_every => false
        hi_code = '<div class="code %s"><div class="box">%s</div></div>' %
            [ language, hi_code ]

        "#{ whitespace_pre }#{ NOTEXTILE % hi_code }"
      end
    end
  end
  #include CodeRay

  module Navigation
    NAVIGATION_TAG_RX = /([\s])?<<'n\:([a-z0-9]+)'/i

    def strip_navigation(text)
      text.gsub! NAVIGATION_TAG_RX, ''
    end
    def navigation(text)
      text.gsub! NAVIGATION_TAG_RX do |m|
        whitespace_pre  = $~[1]
        element_id      = $~[2]
        if navigation = ::Navigation::Container.render(element_id)
          "#{ whitespace_pre }#{ NOTEXTILE % navigation }"
        else
          "p(error). Navigation for #{ element_id } does not exist."
        end
      end
    end
  end
  include Navigation

  class TextileDoc
    attr_accessor :action_view

    def to_markdown(*rules)
      apply_rules(rules)

      to(RedCloth::Formatters::Markdown)
    end
  end

end

