module Categorizable
  class Categorization < ActiveRecord::Base
    set_table_name 'categorizable_categorizations'

    belongs_to :category, :class_name => 'Categorizable::Category', :count_cache => true
    validates_presence_of :category_id
    belongs_to :categorizable, :polymorphic => true
    validates_presence_of :categorizable_type, :categorizable_id

    def self.categorizable_ids_for_names_and_categorizable_type(*args)
      quoted_categorizable_type = quote_categorizable_type args.pop

      select = 'SELECT DISTINCT categorizable_id, categorizable_type' +
          ' FROM categorizable_categorizations' +
          " WHERE category_id IN (#{ collect_category_ids(args) * ',' })" +
          " AND categorizable_type = #{ quoted_categorizable_type }"

      ActiveRecord::Base.connection.select_values select
    end

    protected
    def self.quote_categorizable_type(type)
      categorizable_type_column = columns_hash['categorizable_type']
      quote_value type, categorizable_type_column
    end
    def self.collect_category_ids(names_ids_or_records)
      category_ids = []
      names = names_ids_or_records.delete_if do |n|
        case n
        when Fixnum; category_ids << n
        when ActiveRecord::Base; category_ids << n.id
        end
      end
      if names.empty?
        category_ids
      else
        category_ids | Categorizable::Category.ids_for_names(*names)
      end
    end

    def update_category
      category.update_attribute :update_at, updated_at
    end
    after_save :update_category

  end
end
