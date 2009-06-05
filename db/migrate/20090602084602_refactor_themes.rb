class RefactorThemes < ActiveRecord::Migration
  def self.up
#    add_column :pages, :renew, :boolean
#    Page.reset_column_information
#    updates = {:renew => true, :disposition => 'Composition'}
#    Page.update_all updates, :disposition => 'ThemedPage'

    create_table :page_paths do |t|
      t.references :page

      t.string :path
      t.string :name
      t.string :locale
    end
    add_index :page_paths, [:path], :unique => true
    add_index :page_paths, [:name, :locale], :unique => true

#    create_table :page_components do |t|
#      t.references :composition, :null => false
#      t.references :template
#      t.text :locals
#    end
#    create_table :theme_templates do |t|
#      t.references :template, :null => false
#      t.text :blaaa
#    end
#    create_table :page_composition do |t|
#      t.references :page, :null => false
#      t.references :theme
#    end
  end

  def self.down
    remove_column :pages, :renew
  end
end
