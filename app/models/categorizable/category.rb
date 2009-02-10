module Categorizable
  class Category < ActiveRecord::Base
    set_table_name 'categorizable_categories'

    extend Bulk::Destroy
    registers_path { |category| "/categories/#{ category.to_param }" }

    validates_presence_of :name
    has_many :categorizations, :class_name => 'Categorizable::Categorization',
        :dependent => :delete_all

    def to_s
      name
    end

    def self.find_all_by_names(*names)
      find :all, :conditions => ['name IN (?)', names]
    end
    def self.ids_for_names(*names)
      select = 'SELECT id FROM categorizable_categories'

      name_column = columns_hash['name']
      names.map! { |name| quote_value name, name_column }

      connection.select_values "#{ select } WHERE name IN (#{ names * ',' })"
    end

  end
end
