class Current
  attr_accessor :user, :title

  def initialize
    yield self if block_given?
  end

  def locale
    I18n.locale
  end
  def locale=(locale)
    I18n.locale = locale
  end

end
