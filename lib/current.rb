class Current
  attr_accessor :user, :title

  def initialize
    yield self if block_given?
  end

end
