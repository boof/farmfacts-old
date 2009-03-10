module PathRegistry

  notifies 'Navigation' do |on|
    on.update do
      Navigation.transaction do
        navigations = Navigation.find_all_by_registered_path_id id
        navigations.each { |navigation| navigation.update_attribute :path, path }
      end if path_changed?
    end
    on.destroy do
      Navigation.transaction do
        navigations = Navigation.find_all_by_registered_path_id id
        navigations.each { |navigation| navigation.destroy }
      end
    end
  end

end
