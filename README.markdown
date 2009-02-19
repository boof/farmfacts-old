FarmFacts - Ruby on Rails based CMS
===================================

Minimal CMS based on Ruby on Rails 2.3. It uses some plugins I wrote or
refactored myself. The CMS provides some base functionality like page creation
with attachments, authentication and embedable navigations, and can be
extended with FaFa engines (Blog, Forum, etc.).
The CMS supports themes while every page can be skinned individually.

FEATURED PLUGINS:
-----------------

* column\_scope - as the name says
* action\_sequence - design forms with multiple steps
* shadows - presenter pattern made easy
* acts\_as\_list - fork without the legacy stuff
* categorizable - tagging implementation I like

PLATFORMS (TESTED):
-------------------

* Mac OS X 10.5, Apache2 (mod\_passenger) and PostgreSQL & SQLite3
* Debian 4.0, Apache2 (mod\_passenger) and PostgreSQL

AUDIENCE:
---------

* Developers
* Other

BACKGROUND:
-----------

* I don't want to have rmagick everywhere
* I don't want to have JS (frameworks) everywhere
* I don't want to have a global Media Library
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
    $ git submodule update --init
    $ rake gems:build

Setup:

    # replace sqlite3 with the database of your choice
    $ cp vendor/rails/railties/configs/databases/sqlite3.yml config/database.yml

    # configure your database (replace erbs)
    $ $EDITOR config/database.yml
    $ rake db:create
    $ rake db:migrate

    # the generated session key should only be read by you and your webserver
    $ chmod 600 config/session.key

    # start the webserver and open admin, for example:
    $ script/server
    $ open http://localhost:3000/admin

    # Follow the instructions in your browser...

ROADMAP:
--------

**1.0**

* `Core:    Add metadata where a page inherits metadata from app [New Feature]`
* `FAFA-1:  Template Support [Improvement]`
* `FAFA-2:  Fix CacheSweeper [Bug]`
* `Plugins: Onlist inline option [Improvement]`
* `UI:      Use TinyMCE instead of textile...helper`
* `FAFA-6:  Non-AJAX preview mixin [Improvement]`
* `FAFA-5:  Support Apache's MultiViews language negotiation [New Feature]`

**1.x**

* `FAFA-4:  fafa_articles: Article/Blog Engine for FarmFacts [New Feature]`
* `FAFA-3:  fafa_projects: Project Engine for FarmFacts [New Feature]`
* `Docs:    Missing! [Improvement]`
* Suggestions...

**2.0**

* `Core:    Support for Template Repositories [New Feature]`
* `Core:    Support for FaFa-Engine Repositories [New Feature]`
* `Engines: Vote/Poll [New Feature]`
* `Engines: Wiki [New Feature]`
* `Engines: Forum [New Feature]`
* `Core:    Pluggable Authentication Module, support for LDAP, DB and PAM maybe [Improvement]`
* `FAFA-8:  Page Versioning [Improvement]`
* `Core:    GitHub integration [New Feature]`
* Suggestions...

CREDITS:
--------

* sequel - initial motivation
* fork - further motivation
* dfue - for pleasant support
* haml and paperclip coders for their code
