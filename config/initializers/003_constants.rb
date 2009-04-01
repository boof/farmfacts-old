ATTACHMENT_TYPES = [%w[ Image Attachment::Image ], %w[ Attachment ], %w[ Stylesheet Attachment::Stylesheet ], ['Stylesheet for IE', 'Attachment::Stylesheet::IE'], %w[ Javascript Attachment::Javascript ] ]
DOC_TYPES = [
  ['HTML 4.01 Strict', %Q'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"\n  "http://www.w3.org/TR/html4/strict.dtd">'],
  ['HTML 4.01 Transitional', %Q'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"\n  "http://www.w3.org/TR/html4/loose.dtd">'],
  ['HTML 4.01 Frameset', %Q'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"\n  "http://www.w3.org/TR/html4/frameset.dtd">'],
  ['XHTML 1.0 Strict', %Q'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"\n  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'],
  ['XHTML 1.0 Transitional', %Q'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"\n  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">'],
  ['XHTML 1.0 Frameset', %Q'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN"\n  "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">']
]
LINEBREAKS_RX = /(?:\r\n|\r|\n)/

# Article Engine Properties
# MAILING_LISTS       = 'alpha@mailing-list, beta@mailing-list'
