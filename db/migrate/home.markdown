**[This Site is currently under construction!](/website-todo)**

## Overview

Sequel is a lightweight database access toolkit for Ruby. Sequel provides thread safety, connection pooling and a concise DSL for constructing database queries and table schemas. Sequel also includes a lightweight but comprehensive ORM layer for mapping records to Ruby objects and handling associated records.

Sequel makes it easy to deal with multiple records without having to break your teeth on SQL.

Sequel currently has adapters for ADO, DB2, DBI, Informix, JDBC, MySQL, ODBC, OpenBase, Oracle, PostgreSQL and SQLite3. 

## Installing Sequel

Installing Sequel is easy:

    $ gem install sequel

Be aware, though, that Sequel depends on database adapters for its work. For example, in order to work with sqlite3 database, you need to install the sqlite3 gem. 

## A Short Example

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

**[Getting started](/documentation/getting_started) with Ruby Sequel...**
