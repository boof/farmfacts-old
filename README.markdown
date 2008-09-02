Ruby Sequel - The Ruby Database Toolkit - Is getting a website...
=================================================================

Help Me!
* MISSING: comments management (hide/show)
* MISSING: articles behind the first 10 cannot be accessed
* FEATURE: endless pageless for comments
* MISSING: migrate/write documentation
* FEATURE: convert from ActiveRecord to RubySequel
* FEATURE: votes/polls
* ...
* link this page
* (write a wiki)

You can get the source with:

    git clone git://github.com/boof/www-ruby-sequel-org.git

Don't forget the submodules:

    cd www-ruby-sequel-org
    git submodule init
    git submodule update

Setup your database:

    cp vendor/railties/configs/databases/sqlite3.yml config/database.yml # for example
    EDITOR config/database.yml
    rake db:migrate

You need a User/Login:

    script/generate login