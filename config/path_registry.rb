module PathRegistry

  notifies 'Navigation::Node' do |on|
    on.update do
      Navigation::Node.transaction do
        nodes = Navigation::Node.find_all_by_registered_path_id id
        nodes.each { |node| node.update_attribute :url, path }
      end
    end
    on.destroy do
      Navigation::Node.transaction do
        nodes = Navigation::Node.find_all_by_registered_path_id id
        nodes.each { |node| node.destroy }
      end
    end
  end

end
