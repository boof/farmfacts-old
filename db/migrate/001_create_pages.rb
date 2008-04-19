class CreatePages < ActiveRecord::Migration
  
  def self.up
    create_table :pages do |t|
      t.string :name
      t.string :title
      t.text :body_markdown
      t.text :body
      
      t.timestamps
    end
    add_index :pages, :name, :unique => true
    
    page = Page.new do |page|
      page.name   = 'home'
      page.title  = 'Ruby Sequel - The Database Toolkit for Ruby'
      page.body_markdown = <<-MARKDOWN
## Overview

Sequel is a lightweight database access toolkit for Ruby. Sequel provides thread safety, connection pooling and a concise DSL for constructing database queries and table schemas. Sequel also includes a lightweight but comprehensive ORM layer for mapping records to Ruby objects using the ActiveRecord pattern.

Sequel makes it easy to deal with multiple records without having to break your teeth on SQL.

Sequel currently has adapters for ADO, DB2, DBI, Informix, JDBC, MySQL, ODBC, OpenBase, Oracle, PostgreSQL and SQLite3.

## Installing Sequel

Installing Sequel is easy:

    gem install sequel

Be aware, though, that Sequel depends on database adapters for its work. For example, in order to work with sqlite3 database, you need to install the sqlite3 gem.
MARKDOWN
    end
    
    page.save || raise
    
    page = Page.new do |page|
      page.name   = 'not_found'
      page.title  = '404 - Page not found'
      page.body_markdown = <<-MARKDOWN
Sorry, but this page could not be found.
MARKDOWN
    end
    
    page.save || raise
  end
  
  def self.down
    drop_table :pages
  end
  
end
