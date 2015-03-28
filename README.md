Écrit<sup>[[beta](#todo)]</sup>
=====
([IPA](http://en.wiktionary.org/wiki/Appendix:French_pronunciation): /e.kʁi/)

An extremely-opinionated Node app framework. Écrit is highly oriented toward readability, accessibility and logical, intuitive code organization. MongoDB is the database of choice here.
Use this framework as a more versatile alternative to Ghost or Wordpress, or if you've used a similar framework like Sails but prefer Literate CoffeeScript as much as we do.

Install
-------

First, [Install MongoDB.](http://docs.mongodb.org/manual/installation/)  

Next, install Écrit via NPM. Open up your Terminal and type

`npm install -g ecrit`

The `-g` flag is mandatory, as this is a command-line tool. 

Now you're good to go! Type `ecrit -v` to confirm you've installed it and see which version you're using.

Commands
--------

### `ecrit create [folder]`

Creates an app at `[folder]` where `[folder]` is a relative path to an existing empty directory.  
If `[folder]` doesn't exist within the current working directory, it will be created.

### `ecrit start`

Starts an Écrit app, from within its' root folder. 

### `ecrit test [--option]`

Runs unit tests for the framework. Currently only `--console` option is supported.

###### TODO

* Finish building out tests
* Design and build out Dashboard features

