## Sequel - a lightweight database toolkit for Ruby
* Sequel provides thread safety, connection pooling and a concise DSL for constructing database queries and table schemas.
* Sequel also includes a lightweight but comprehensive ORM layer for mapping records to Ruby objects and handling associated records.
* Sequel makes it easy to deal with multiple records without having to break your teeth on SQL.
* Sequel currently has adapters for ADO, DB2, DBI, Informix, JDBC, MySQL, ODBC, OpenBase, Oracle, PostgreSQL and SQLite3.

### A short example:

{: lang=ruby html_use_syntax}
    # connect to an in-memory database
    DB = Sequel.sqlite
    
    # create an items table
    DB.create_table :items do
      column :name, :text
      column :price, :float
    end
    
    # create a dataset from the items table
    items = DB[:items]
    
    # populate the table
    items << {:name => 'abc', :price => rand * 100}
    items << {:name => 'def', :price => rand * 100}
    items << {:name => 'ghi', :price => rand * 100}
    
    # print out the number of records
    puts "Item count: #{ items.count }"
    
    # print out the records in descending order by price
    items.reverse_order(:price).print
    
    # print out the average price
    puts "The average price is: #{ items.avg :price }"

## [Getting started](/documentation/getting_started) with Ruby Sequel...
