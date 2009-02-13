class ApplicationController < ActionController::Base; protected

  Preferences[:FarmFacts].instance_eval do
    ExceptionNotifier.exception_recipients = server_recipients
    ExceptionNotifier.sender_address       = server_sender
    ExceptionNotifier.email_prefix         = "[#{ name }] "
  end

  include ExceptionNotifiable

  helper :all
  filter_parameter_logging %w[ password ]

  def rescue_action(exception)
    case exception
    when Unauthorized
      @page_title = '401 Unauthorized'
      render_401
    else super
    end
  end

  def restart
    # restart Ruby on Rails instances spawned by Passenger.
    FileUtils.touch Rails.root.join('tmp', 'restart.txt')
  end

  def frontpage_path
    Preferences[:FarmFacts].frontpage_path
  end
  helper_method :frontpage_path

  def page
    @__page ||= Page.default
  end
  helper_method :page

end
