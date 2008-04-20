## Getting Started

TODO: Put up a little Example from Migrations to Joins and explain it.

### Installing Sequel

Installing Sequel is easy:

{: lang=sh html_use_syntax}
    $ gem install sequel

Be aware, though, that Sequel depends on database adapters for its work. For example, in order to work with sqlite3 database, you need to install the sqlite3 gem.

### A Short Example

{: lang=ruby html_use_syntax}
    require 'rubygems'
    require 'sequel'

    DB = Sequel.sqlite # memory database

    DB.create_table :items do # Create a new table
      column :name, :text
      column :price, :float
    end

    items = DB[:items] # Create a dataset

    # Populate the table
    items << {:name => 'abc', :price => rand * 100}
    items << {:name => 'def', :price => rand * 100}
    items << {:name => 'ghi', :price => rand * 100}

    # Print out the number of records
    puts "Item count: #{items.count}"

    # Print out the records in descending order by price
    items.reverse_order(:price).print

    # Print out the average price
    puts "The average price is: #{items.avg(:price)}"

### Connecting to a database

To connect to a database you simply provide Sequel with a URL:

{: lang=ruby html_use_syntax}
    require 'sequel'
    DB = Sequel.open 'sqlite:///blog.db'

The connection URL can also include such stuff as the user name and password:

{: lang=ruby html_use_syntax}
    DB = Sequel.open 'postgres://cico:12345@localhost:5432/mydb'

You can also specify optional parameters, such as the connection pool size, or a logger for logging SQL queries:

{: lang=ruby html_use_syntax}
    DB = Sequel.open("postgres://postgres:postgres@localhost/my_db",
      :max_connections => 10, :logger => Logger.new('log/db.log'))


### Arbitrary SQL queries

{: lang=ruby html_use_syntax}
    DB.execute("create table t (a text, b text)")
    DB.execute("insert into t values ('a', 'b')")

Or more succinctly:

{: lang=ruby html_use_syntax}
    DB << "create table t (a text, b text)"
    DB << "insert into t values ('a', 'b')"

You can also fetch records with raw SQL:

{: lang=ruby html_use_syntax}
    DB['select * from items'].each do |row|
      p row
    end

You can also create datasets based on raw SQL:

{: lang=ruby html_use_syntax}
    dataset = DB['select * from items']
    dataset.count # will return the number of records in the result set
    dataset.map(:id) # will return an array containing all values of the id column in the result set


### Creating Dataset Instances

Dataset is the primary means through which records are retrieved and manipulated. You can create an blank dataset by using the dataset method:

{: lang=ruby html_use_syntax}
    dataset = DB.dataset

Or by using the from methods:

{: lang=ruby html_use_syntax}
    posts = DB.from(:posts)

You can also use the equivalent shorthand:

{: lang=ruby html_use_syntax}
    posts = DB[:posts]

Note: the dataset will only fetch records when you explicitly ask for them, as will be shown below. Datasets can be manipulated to filter through records, change record order and even join tables, as will also be shown below.


### Fetching Records

You can fetch records by using the all method:

{: lang=ruby html_use_syntax}
    posts.all

The all method returns an array of hashes, where each hash corresponds to a record.

You can also iterate through records one at a time:

{: lang=ruby html_use_syntax}
    posts.each {|row| p row}

Or perform more advanced stuff:

{: lang=ruby html_use_syntax}
    posts.map(:id)
    posts.inject({}) {|h, r| h[r[:id]] = r[:name]}

You can also retrieve the first record in a dataset:

{: lang=ruby html_use_syntax}
    posts.first

Or retrieve a single record with a specific value:

{: lang=ruby html_use_syntax}
    posts[:id => 1]

If the dataset is ordered, you can also ask for the last record:

{: lang=ruby html_use_syntax}
    posts.order(:stamp).last


### Filtering Records

The simplest way to filter records is to provide a hash of values to match:

{: lang=ruby html_use_syntax}
    my_posts = posts.filter(:category => 'ruby', :author => 'david')

Sequel lets you filter using ranges, arrays of values or even using other datasets as sub-queries. Sequel also lets you specify advanced filters in Ruby and automagically translates your code into SQL:

{: lang=ruby html_use_syntax}
    old_nonruby_posts = posts.filter {:stamp > 1.month.ago && :category != 'ruby'}

You can read more about dataset filters here: FilteringRecords.


### Summarizing Records

Counting records is easy:

{: lang=ruby html_use_syntax}
    posts.filter(:category => /ruby/i).count

And you can also query maximum/minimum values:

{: lang=ruby html_use_syntax}
    max_value = DB[:history].max(:value)


Or calculate a sum:

{: lang=ruby html_use_syntax}
    total = DB[:items].sum(:price)


### Ordering Records

{: lang=ruby html_use_syntax}
    posts.order(:stamp)

You can also specify descending order

{: lang=ruby html_use_syntax}
    posts.order(:stamp.desc)


### Deleting Records

{: lang=ruby html_use_syntax}
    posts.filter('stamp < ?', 3.days.ago).delete

### Inserting Records

{: lang=ruby html_use_syntax}
    posts.insert(:category => 'ruby', :author => 'david')

Or alternatively:

{: lang=ruby html_use_syntax}
    posts << {:category => 'ruby', :author => 'david'}

### Updating Records

{: lang=ruby html_use_syntax}
    posts.filter('stamp < ?', 3.days.ago).update(:state => 'archived')

### Joining Tables

Joining is very useful in a variety of scenarios, for example many-to-many relationships. With Sequel it's really easy:

{: lang=ruby html_use_syntax}
    order_items = DB[:items].join(:order_items, :item_id => :id).filter(:order_items__order_id => 1234)

This is equivalent to the SQL:

{: lang=sql html_use_syntax}
    SELECT * FROM items LEFT OUTER JOIN order_items
      ON order_items.item_id = items.id 
      WHERE order_items.order_id = 1234

You can then do anything you like with the dataset:

{: lang=ruby html_use_syntax}
    order_total = order_items.sum(:price)

Which is equivalent to the SQL:

{: lang=sql html_use_syntax}
    SELECT sum(price) FROM items LEFT OUTER JOIN order_items
      ON order_items.item_id = items.id
      WHERE order_items.order_id = 1234