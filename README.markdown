FarmFacts - Ruby on Rails based CMS
===================================

PLATFORMS:
----------

* Mac OS X 10.5, Apache2 (mod\_passenger) and PostgreSQL
* Debian 4.0, Apache2 (mod\_passenger) and PostgreSQL

AUDIENCE:
---------

* Developers
* Other

BACKGROUND:
-----------

* I don't want to have rmagick everywhere
* I don't want to have JS everywhere in the admin ui
* I don't want to have a Media Library
* I want to use the latest Rails version
* I want to use solid technologies
* I want it to be fast
* I want to give Ruby Sequel a CMS
* I want to give Fork Unstable Media - TECH a CMS
* actually I want to write something big / a CMS / kill time

INSTALL:
--------

You can get the source with:

    $ git clone git://github.com/boof/farmfacts.git

Don't forget the submodules:

    $ cd farmfacts
    $ git submodule init
    $ git submodule update

Setup:

    # replace sqlite3 with the database of your choice
    $ cp vendor/rails/railties/configs/databases/sqlite3.yml config/database.yml

    $ $EDITOR config/database.yml
    $ rake gems:build
    $ rake db:create
    $ rake db:migrate

    # the generated session key should only be read by you and your webserver
    $ chmod 600 config/session.key

    ...

ROADMAP:
--------

**1.0**

* `FAFA-7:  Application/Engine Properties [Improvement]`
* `Core: Add metadata where a page inherits metadata from app [New Feature]`
* `FAFA-1:  Template Support [Improvement]`
* `FAFA-2:  Fix CacheSweeper [Bug]`
* `FAFA-4:  fafa_articles: Article/Blog Engine for FarmFacts [Improvement]`
* `Plugins: Onlist inline option [Improvement]`
* `UI: Use TinyMCE instead of textile...helper`
* `FAFA-6:  Non-AJAX preview mixin [Improvement]`

**1.x**

* `FAFA-5:  Support Apache's MultiViews language negotiation [New Feature]`
* `Documentation: Missing! [Bug]`
* `FAFA-3:  fafa_projects: Project Engine for FarmFacts [Improvement]`
* `Engines: Vote/Poll [New Feature]`
* `Engines: Wiki [New Feature]`
* `Engines: Forum [New Feature]`
* `Suggestions...`

**2.0**

* `Core / Auth: Pluggable Authentication Module, support for LDAP, DB and PAM maybe [Improvement]`
* `FAFA-8:  Page Versioning [Improvement]`
* `Core: GitHub integration [New Feature]`
* `Suggestions...`
