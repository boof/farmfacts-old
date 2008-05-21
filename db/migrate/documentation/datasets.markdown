## 4. Models

 1. [Introduction](#41_introduction)
 2. [Classes](#42_classes)
   1. Something
   2. [Extend Datasets](#422_extend_datasets)
   3. [Define Schemas](#423_define_schemas)
   4. [Hooks](#424_hooks)
   5. [Validations](#425_validations)
   6. [Plugins](#426_plugins)
   7. [NotNaughty](#427_notnaughty)
 3. [Instances](#43_instances)
   1. [Create Records](#431_create_records)
   2. [Read Records](#432_read_records)
   3. [Update Records](#433_update_records)
   4. [Delete Records](#434_delete_records)
   5. [Caching Instances](#435_caching_instances)
 4. [Associations](#44_associations)


### 4.1. Introduction
Models in Ruby Sequel are based on the [Active Record pattern described by Martin Fowler](http://www.martinfowler.com/eaaCatalog/activeRecord.html). A model class corresponds to a table or a dataset, and an instance of that class wraps a single record in the model's underlying dataset.

To use models you need to install the sequel gem in addition to the sequel\_core gem:

    $ sudo gem install sequel

### 4.2. Classes
Models are defined like regular Ruby classes:

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model
    end

    # models assume their tablename as plural of its class name
    Post.table_name #=> :posts

You can explicitly set the dataset:

{: lang=ruby html_use_syntax}
    # with a tablename
    Post.set_dataset :posts_table
    # with a dataset
    Post.set_dataset DB[:posts_table].where(:spam => false)

You can also define the used dataset by passing it to the class factory:

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model(:posts_table)
    end

_See also:
 Sequel.Model,
 [Sequel::Model#set\_dataset](http://sequel.rubyforge.org/classes/Sequel/Model.html#M000365),
 [Sequel::Database#\[\]](http://sequel.rubyforge.org/classes/Sequel/Database.html#M000452),
 [Sequel::Dataset::SQL#where](http://sequel.rubyforge.org/classes/Sequel/Dataset/SQL.html#M000576)_

### 4.2.2. Extend Datasets

The obvious way to add table-wide logic is to define class methods to the model class definition. That way you can define subsets of the underlying dataset, change the ordering, or perform actions on multiple records:

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model
      def self.old_posts
        filter {:stamp < 30.days.ago}
      end
      
      def self.clean_old_posts
        old_posts.delete
      end
    end

You can also implement table-wide logic by defining methods on the dataset:

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model
      def dataset.old_posts
        filter {:stamp < 30.days.ago}
      end
      
      def dataset.clean_old_posts
        old_posts.delete
      end
    end

This is the recommended way of implementing table-wide operations, and allows you to have access to your model API from filtered datasets as well:

{: lang=ruby html_use_syntax}
    Post.filter(:category => 'ruby').clean_old_posts

Sequel models also provide a short hand notation for filters:

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model
      subset(:old_posts) {:stamp < 30.days.ago}
      subset :invisible, :visible => false
    end

### 4.2.3. Define Schemas

Model classes can also be used as a place to define your table schema and control it. The schema DSL is exactly the same provided by Sequel::Schema::Generator:

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model
      set_schema do
        primary_key :id
        text :title
        text :category
        foreign_key :author_id, :table => :authors
      end
    end

You can then create the underlying table, drop it, or recreate it:

{: lang=ruby html_use_syntax}
    Post.table_exists?
    Post.create_table
    Post.drop_table
    Post.create_table! # drops the table if it exists and then recreates it


### 4.2.4. Hooks

You can execute custom code when creating, updating, or deleting records by using hooks. The before\_create and after\_create hooks wrap record creation. The before\_update and after\_update wrap record updating. The before\_save and after\_save wrap record creation and updating. The before\_destroy and after\_destroy wrap destruction.

Hooks are defined by supplying a block:

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model
      after_create do
        set :created_at => Time.now
      end
    
      after_destroy do
        author.update_post_count
      end
    end
Note: They're instance'evaled!


### 4.2.5. Validations

To assign default validations to a sequel model:

{: lang=ruby html_use_syntax}
    class MyModel < SequelModel
      validates do
        format_of...
        presence_of...
        acceptance_of...
        confirmation_of...
        length_of...
        numericality_of...
        format_of...
        each...
      end
    end

You may also perform the usual 'longhand' way to assign default model validates directly within the model class itself:

{: lang=ruby html_use_syntax}
    class MyModel < SequelModel
      validates_format_of...
      validates_presence_of...
      validates_acceptance_of...
      validates_confirmation_of...
      validates_length_of...
      validates_numericality_of...
      validates_format_of...
      validates_each...
    end

TODO: Describe arguments.


### 4.3. Instances

Model instance are identified by a primary key. By default, Ruby Sequel assumes the primary key column to be :id. The Model.\[\] method can be used to fetch records by their primary key:

{: lang=ruby html_use_syntax}
    post = Post[123]
    post.pk #=> 123

Sequel models allow you to use any number of columns as a (composite) primary key:

{: lang=ruby html_use_syntax}
    Post.set_primary_key :category, :title
    
    post = Post['ruby', 'hello world']
    post.pk #=> ['ruby', 'hello world']

Note: You can also define a model class that does not have a primary key, but then you lose the ability to update records.

A model instance can also be fetched by specifying a condition:

{: lang=ruby html_use_syntax}
    post = Post[:title => 'hello world']
    post = Post.find {:stamp < 10.days.ago}


### 4.3.1. Create Records

New records can be created by calling Model.create:

{: lang=ruby html_use_syntax}
    Post.create :title => 'hello world'

Another way is to construct a new instance and save it:

{: lang=ruby html_use_syntax}
    post = Post.new
    post.title = 'hello world' and post.save

You can also supply a block to Model.new and Model.create:

{: lang=ruby html_use_syntax}
    Post.create do |p|
      p.title = 'hello world'
    end
    
    Post.new do |p|
      p.title = 'hello world' and p.save
    end


### 4.3.2. Read Records

A model class lets you iterate over specific records by acting as a proxy to the underlying dataset. This means that you can use the entire Dataset API to create customized queries that return model instances, e.g.:

{: lang=ruby html_use_syntax}
    Post.filter(:category => 'ruby').each {|post| p post}

You can also manipulate the records in the dataset:

{: lang=ruby html_use_syntax}
    Post.filter {:stamp < 7.days.ago}.delete
    Post.filter {:title =~ /ruby/}.update(:category => 'ruby')


### 4.3.3. Update Records

A model instances stores its values as a hash:

{: lang=ruby html_use_syntax}
    post.values #=> {:id => 123, :category => 'ruby', :title => 'hello world'}

You can read the record values as object attributes:

{: lang=ruby html_use_syntax}
    post.id #=> 123
    post.title #=> 'hello world'

You can also change record values:

{: lang=ruby html_use_syntax}
    post.title = 'hey there' and post.save # updates the whole row
    post.set(:title => 'hey there') # only updates the field


### 4.3.4. Delete Records

You can delete individual records by calling #delete or #destroy. The only difference between the two methods is that #destroy invokes before_destroy and after_destroy hooks, while #delete does not:

{: lang=ruby html_use_syntax}
    post.delete #=> bypasses hooks
    post.destroy #=> runs hooks


Records can also be deleted en-masse by invoking Model.delete and Model.destroy. As stated above, you can specify filters for the deleted records:

{: lang=ruby html_use_syntax}
    Post.filter(:category => 32).delete #=> bypasses hooks
    Post.filter(:category => 32).destroy #=> runs hooks

Note: If Model.destroy is called, each record is deleted separately, but Model.delete deletes all relevant records with a single SQL statement.


### 4.3.5. Caching Instances

Sequel models can be cached using memcached based on their primary keys. The use of memcached can significantly reduce database load by keeping model instances in memory. The set\_cache method is used to specify caching:

{: lang=ruby html_use_syntax}
    require 'memcache'
    CACHE = MemCache.new 'localhost:11211', :namespace => 'blog'
    
    class Author < Sequel::Model
      set_cache CACHE, :ttl => 3600
    end
    
    Author[333] # database hit
    Author[333] # cache hit


### 4.4. Associations

Associations are used in order to specify relationships between model classes that reflect relations between tables in the database using foreign keys.

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model
      many_to_one :author
      one_to_many :comments
      many_to_many :tags
    end

You can also use the ActiveRecord names for these associations:

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model
      belongs_to :author
      has_many :comments
      has_and_belongs_to_many :tags
    end

many\_to\_one/belongs\_to creates a getter and setter for each model object:

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model
      many_to_one :author
    end
    
    post = Post.create(:name => 'hi!')
    post.author = Author[:name => 'Sharon']
    post.author

one\_to\_many/has\_many and many\_to\_many/has\_and\_belongs\_to\_many create a getter method, a method for adding an object to the association, and a method for removing an object from the association:

{: lang=ruby html_use_syntax}
    class Post < Sequel::Model
      one_to_many :comments
      many_to_many :tags
    end
    
    post = Post.create(:name => 'hi!')
    post.comments
    comment = Comment.create(:text=>'hi')
    post.add_comment(comment)
    post.remove_comment(comment)
    tag = Tag.create(:tag=>'interesting')
    post.add_tag(tag)
    post.remove_tag(tag)

Associations can be eagerly loaded via .eager and the :eager association option. Eager loading is used when loading a group of objects. It loads all associated objects for all of the current objects in one query, instead of using a separate query to get the associated objects for each current object. Eager loading requires that you retrieve all model objects at once via .all (instead of individually by .each). Eager loading can be cascaded, loading association's associated objects.

{: lang=ruby html_use_syntax}
    class Person < Sequel::Model
      one_to_many :posts, :eager=>[:tags]
    end
    
    class Post < Sequel::Model
      many_to_one :person
      one_to_many :replies
      many_to_many :tags
    end
    
    class Tag < Sequel::Model
      many_to_many :posts
      many_to_many :replies
    end
    
    class Reply < Sequel::Model
      many_to_one :person
      many_to_one :post
      many_to_many :tags
    end
    
    # Eager loading via .eager
    Post.eager(:person).all
    
    person = Person.first
    # Eager loading via :eager (will eagerly load the tags for this person's posts)
    person.posts
    
    # These are equivalent
    Post.eager(:person, :tags).all
    Post.eager(:person).eager(:tags).all
    
    # Cascading via .eager
    Tag.eager(:posts=>:replies).all
    
    # Will also grab all associated posts' tags (because of :eager)
    Reply.eager(:person=>:posts).all
    
    # No depth limit (other than memory/stack), and will also grab posts' tags
    # Loads all people, their posts, their posts' tags, replies to those posts,
    # the person for each reply, the tag for each reply, and all posts and
    # replies that have that tag.  Uses a total of 8 queries.
    Person.eager(:posts=>{:replies=>[:person, {:tags=>{:posts, :replies}}]}).all
