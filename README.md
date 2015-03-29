Écrit<sup>[[beta](#todo)]</sup>
=====
([IPA](http://en.wiktionary.org/wiki/Appendix:French_pronunciation): /e.kʁi/)

![Travis CI Build Status](https://travis-ci.org/merciba/ecrit.svg?branch=master)  
![NPM Stats](https://nodei.co/npm/ecrit.png)

An extremely-opinionated Node app framework. Écrit is highly oriented toward readability, accessibility and logical, intuitive code organization. MongoDB is the database of choice here.
Use this framework as a more versatile alternative to Ghost or Wordpress, or if you've used a similar framework like Sails but prefer Literate CoffeeScript as much as we do.

Install
-------

First, make sure you have a Mongo database running somewhere.  
If you're using a hosted service like [Compose](http://compose.io), have your database's URL, username and password on hand, you'll need them for the following steps.  

_Note:_ If you're just developing or want to use a self-hosted MongoDB, you'll need to [Install MongoDB](http://docs.mongodb.org/manual/installation/) if it's not already installed.  
Make sure you run `mongod` (may require sudo) and in another Terminal, confirm the DB is running with `netstat -an | grep 27017`. If you get any results, Mongo is running.

Next, install Écrit via NPM. Open up your Terminal and type

`npm install -g ecrit`

The `-g` flag is mandatory, as this is a command-line tool.  

Now you're good to go! Type `ecrit -v` to confirm you've installed it and see which version you're using.

Quick Start
-------

```
ecrit create exampleApp  
cd exampleApp && ecrit start
```

Commands
--------

#### [`ecrit create [folder]`](https://github.com/merciba/ecrit/blob/master/bin/create.litcoffee)

Creates an app at `[folder]` where `[folder]` is a relative path to an existing empty directory.  
If `[folder]` doesn't exist within the current working directory, it will be created.

#### [`ecrit start`](https://github.com/merciba/ecrit/blob/master/bin/start.litcoffee)

Starts an Écrit app. Must be within `[folder]`, cannot be invoked from subdirectories or parent(s). 

#### [`ecrit test [--folder]`](https://github.com/merciba/ecrit/blob/master/bin/test.litcoffee)

Runs unit tests for the framework. Currently only `--console` option is supported.

###### TODO

* Finish building out tests
* Design and build out Dashboard features

