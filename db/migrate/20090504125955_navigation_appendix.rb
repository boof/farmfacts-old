class NavigationAppendix < ActiveRecord::Migration
  def self.up
    change_table(:navigations) { |t| t.text :appendix }

    Navigation.reset_column_information
    Navigation.find(:all).each do |n|
      n.appendix = {
        :class  => n.blank?? 'hidden' : '',
        :href   => n.path,
        :title  => n.label
      }
      n.instance_eval { update_without_callbacks }
    end
  end

  def self.down
    change_table(:navigations) { |t| t.remove :appendix }
  end
end
