module LocalizationHelper

  # TODO: detect of timezone, fallback to default
  def current_timezone
    TimeZone.new 'Berlin'
  end
  def current_time
    ActiveSupport::TimeWithZone.new Time.now, current_timezone
  end

end
