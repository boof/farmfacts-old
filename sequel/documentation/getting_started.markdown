## Getting Started with Ruby Sequel
First you need to install the gem:

    $ sudo gem install sequel-core

Note: Sequel depends on database adapters for it to work. For example, in order to work with sqlite3 database, you need to install the sqlite3 gem. 


### Interact with a database, through raw SQL
To connect to a database you simply provide Sequel with a URL:

{: lang=ruby html_use_syntax}
    require 'sequel'
    DB = Sequel.connect 'sqlite:///' # in-memory db

The connection URL can also include the user name and password and you can specify optional parameters, such as the connection pool size, encoding[^1] or a logger for logging SQL queries:

{: lang=ruby html_use_syntax}
    DB = Sequel.open 'postgres://me:**secret**@localhost/my_db',
      :max_connections => 10,
      :encoding => 'unicode',
      :logger => Logger.new('log/db.log')


After you connected to your database you can execute arbitrary SQL queries:

{: lang=ruby html_use_syntax}
    DB.execute "create table tbl (a text, b text)" # is like
    DB << "create table tbl (a text, b text)"
    # and
    DB.execute "insert into tbl values ('a', 'b')" # is like
    DB << "insert into tbl values ('a', 'b')"

*See also [Sequel::Database](/documentation/databases).*


### Manipulate schemas with migrations
The migrator works in very similar fashion to ActiveRecord migrations. Each
migration is defined as a descendant of Sequel::Migration with `#up` and `#down`
methods:

{: lang=ruby html_use_syntax}
    class CreateManagers < Sequel::Migration
      
      def up
        create_table :managers do
          boolean :active
          varchar :name
          integer :salary
        end
      end
      
      def down() drop_table :managers end
      
    end

Manually apply the migration as follows:

{: lang=ruby html_use_syntax}
    CreateManagers.apply DB, :up
    # => ["CREATE TABLE managers (active boolean, name varchar(255), salary integer)"]

*See also [Sequel::Migration](/documentation/migrations).*


### Interact with a database - through Datasets
Dataset is the primary means through which records are retrieved and manipulated.

Create a dataset

{: lang=ruby html_use_syntax}
    managers = DB[:managers] # => #<Sequel::SQLite::Dataset: "SELECT * FROM managers">
    # and chain them
    exp_managers = managers.where(:salary => 10_000..20_000).order(:name)
    # => #<Sequel::SQLite::Dataset: "SELECT * FROM managers WHERE (salary >= 10000 AND salary <= 20000) ORDER BY name">

Using datasets

{: lang=ruby html_use_syntax}
    # to create a record
    managers << {:name => 'Top Manager', :salary => 50_000} # => 1
    # to update a record
    managers.filter('salary < ?', 10_000).update(:active => true) # => 0
    # to delete a record
    managers.filter(:active => nil).delete # => 1

*See also [Sequel::Dataset](/documentation/datasets).*


### From Datasets to Models
Models in Ruby Sequel are based on the [Active Record pattern described by Martin Fowler](http://www.martinfowler.com/eaaCatalog/activeRecord.html). A model class corresponds to a table or a dataset, and an instance of that class wraps a single record in the model's underlying dataset.

To use models you need to install the sequel gem in addition to the sequel\_core gem:

    $ sudo gem install sequel

TODO: Short intro.

*See also [Sequel::Model](/documentation/models).*


[^1]: Thanks Chu Yeow for pointing this out.