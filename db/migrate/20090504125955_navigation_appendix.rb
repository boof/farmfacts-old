class NavigationAppendix < ActiveRecord::Migration
  def self.up
    change_table(:navigations) { |t| t.text :appendix }
  end

  def self.down
    change_table(:navigations) { |t| t.remove :appendix }
  end
end
