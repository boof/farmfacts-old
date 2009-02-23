class Admin::DashboardController < Admin::Base

  def index
    current.title = "Welcome #{ current.user }"
  end

end