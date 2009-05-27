FarmFacts - Ruby on Rails based CMS
===================================

Minimal CMS based on Ruby on Rails 2.3+. It uses some plugins I wrote or
refactored myself. The CMS provides some base functionality like page creation
with attachments, authentication and embedable navigations, and can be
extended with engines written for FarmFacts (Blog, Forum, ...).
The CMS supports themes while every page can be handwritten.

FEATURED PLUGINS:
-----------------

* column\_scope - as the name says
* action\_sequence - design forms with multiple steps
* shadows - presenter pattern made easy
* acts\_as\_list - fork without the legacy stuff

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

1. I don't want to have rmagick everywhere
2. I don't want to have JS (frameworks) everywhere
3. I don't want to have a global Media Library
4. I want to use the latest Rails version
5. I want to use solid technologies
6. I want it to be fast
7. I want to give Ruby Sequel a CMS
8. I want to give Fork Unstable Media - TECH a CMS
9. actually I want to write something big / a CMS / kill time

INSTALL:
--------

You can get the source with:

    $ git clone git://github.com/boof/farmfacts.git

Don't forget the submodules:

    $ cd farmfacts
    $ git checkout -b SQUEEZE origin/SQUEEZE
    $ git submodule update --init
    $ rake gems:build

Development Setup:

    # replace sqlite3 with the database of your choice
    $ cp vendor/rails/railties/configs/databases/sqlite3.yml config/database.yml

    # configure your database (replace ERbs)
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

**0.6**

* refactor Theme engine
    * performance optimization
    * tests
    * documentation
    * preview
    * locking
* remove obsolete files and code
* improve shadows for testability

**0.7**

* refactor Navigation
    * drop nested set and serialize a XML document
    * improve a12n interface for usability
    * tests

**0.8**

* refactor a12n base controllers to simplify customizations
* tests

**0.9**

* documentation

**1.0**

* refactor Authentication and Authorization
    * check ACLs before manipuating data
    * documentation

**1.x**

* fafa_articles engines a Article/Blog System
    * GitHub integration
* fafa_votes engines a Vote/Poll
* fafa_message engines a Messaging System

**2.x**

* support for Theme Channels
    * support for theme package format
    * support for versions
* fafa_projects: Project Engine
* fafa_wiki: Wiki Engine
* fafa_forum: Forum Engine
* support for Engine Channels
* support page versioning
* ApPaRaPo stack configurations (well...)

* plugins: Onlist inline option

CREDITS:
--------

* Sharon Rosner and Jeremy Evans - initial motivation
* alexander, dfü & Fork Unstable Media - possibility, support
* all open source developers, thanks!
