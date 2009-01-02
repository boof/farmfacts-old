FarmFacts - Ruby on Rails based CMS
===================================

TODO
----

Essential:
* some Cache Sweeper are missing
* Non-AJAX fallback for preview
* Templating through Pages: Page => [Blog, Projects, Categories]

Misc:
* Localizations
* Coarse should fallback to Rails.logger
* GitHub requests should be cached
* CAS
* votes and polls
* Trackbacks:
  * Project

You can get the source with:

    git clone git://github.com/boof/farmfacts.git

Don't forget the submodules:

    cd farmfacts
    git submodule init
    git submodule update

Setup:

    $ # replace sqlite3 with the database of your choice
    $ cp vendor/rails/railties/configs/databases/sqlite3.yml config/database.yml

    $ $EDITOR config/database.yml
    $ rake db:migrate

    ...
