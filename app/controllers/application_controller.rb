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
    # restart this apps instances spawned by passenger.
    FileUtils.touch Rails.root.join('tmp', 'restart.txt')
    # restart this very instance of mongrel.
    #Process.kill 'USR2', Process.pid
    # restart this very instance of thin.
    #Process.kill 'HUP', Process.pid
  end

  def frontpage_path
    Preferences[:FarmFacts].frontpage_path
  end
  helper_method :frontpage_path

end
