class Admin::DashboardController < Admin::Base

  def index
    current.title = translate :welcome, :name => current.user
  end

end
