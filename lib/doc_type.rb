class DocType

  TYPES = [
    ['HTML 4.01 Strict', {}, %Q'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"\n  "http://www.w3.org/TR/html4/strict.dtd">'],
    ['HTML 4.01 Transitional', {}, %Q'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"\n  "http://www.w3.org/TR/html4/loose.dtd">'],
    ['HTML 4.01 Frameset', {}, %Q'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"\n  "http://www.w3.org/TR/html4/frameset.dtd">'],
    ['XHTML 1.0 Strict', { :xmlns => 'http://www.w3.org/1999/xhtml' }, %Q'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"\n  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'],
    ['XHTML 1.0 Transitional', { :xmlns => 'http://www.w3.org/1999/xhtml' }, %Q'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'],
    ['XHTML 1.0 Frameset', { :xmlns => 'http://www.w3.org/1999/xhtml' }, %Q'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"\n  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">']
  ]

  HTML_ATTRIBUTES, LABELS = Hash.new { |h, k| {} }, {}
  TYPES.each do |(label, attributes, definition)|
    HTML_ATTRIBUTES[definition] = attributes
    LABELS[definition] = label
  end

  attr_accessor :doctype

  def initialize(doctype)
    @doctype = doctype
  end

  def label
    LABELS[@doctype]
  end
  def to_hash(other_hash = nil)
    attributes = HTML_ATTRIBUTES[@doctype]
    other_hash ? other_hash.merge(attributes) : attributes
  end
  def to_s
    @doctype
  end

end
