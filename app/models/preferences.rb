class Preferences < ActiveRecord::Base

  serialize :data, Hash

end
