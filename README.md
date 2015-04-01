Écrit<sup>[[beta](#todo)]</sup>
=====
[IPA](http://en.wiktionary.org/wiki/Appendix:French_pronunciation): /e.kʁi/ - that's "eh-cree"  

[![NPM](https://nodei.co/npm/ecrit.png)](https://nodei.co/npm/ecrit/)  

[![Travis CI Build Status](https://travis-ci.org/merciba/ecrit.svg?branch=master)](https://travis-ci.org/merciba/ecrit) [![NPM Downloads](https://img.shields.io/npm/dm/ecrit.svg)](https://www.npmjs.com/package/ecrit) [![Dependency Status](https://img.shields.io/david/merciba/ecrit.svg)](https://david-dm.org/merciba/ecrit) [![License](https://img.shields.io/npm/l/ecrit.svg)](https://github.com/merciba/ecrit/blob/master/LICENSE) [![Gratipay](http://img.shields.io/gratipay/merciba.svg)](https://gratipay.com/merciba/)

An extremely-opinionated Node app framework. Écrit is highly oriented toward readability, accessibility and logical, intuitive code organization. MongoDB is the database of choice here.  
Use this framework as a more versatile alternative to Ghost or Wordpress, or if you've used a similar framework like Sails but prefer Literate CoffeeScript as much as we do.

Install
-------

First, make sure you have a Mongo database running somewhere.  
If you're using a hosted service like [Compose](http://compose.io), have your database's URL, username and password on hand, you'll need them for the following steps.  

_Note:_ If you're just developing or want to use a self-hosted MongoDB, you'll need to [Install MongoDB](http://docs.mongodb.org/manual/installation/) if it's not already installed. Make sure you run `mongod` (may require sudo) and in another Terminal, confirm the DB is running with `netstat -an | grep 27017`. If you get any results, Mongo is running.

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

#### [`ecrit create <app name>`](/bin/create.litcoffee)

Creates an app at folder `<app name>` within the current working directory.  
If the folder doesn't exist, it will be created.  
If the folder exists and is empty, Écrit will copy a new app to the directory.  
If the folder exists and is not empty, Écrit will return an error.  

#### [`ecrit start <environment>`](/bin/start.litcoffee)

Starts an Écrit app. Must be within `<app name>`, cannot be invoked from subdirectories or parent(s).  
If no `<environment>` provided, defaults to 'development'.  

If called with `production`, Écrit automatically launches your app in the background and load-balances it between all CPU threads for production use.  
Under the hood, we're leveraging [PM2](https://github.com/Unitech/pm2), an ideal choice because of its' reputation and compatibility with [Keymetrics](https://keymetrics.io/) app monitoring suite. 

#### [`ecrit show <app name>`](https://github.com/merciba/ecrit/blob/master/bin/show.litcoffee)

Shows info about an Écrit app with the given `<app name>`.  
If no `<app name>`, assumes current directory.  

#### [`ecrit restart <app name>`](https://github.com/merciba/ecrit/blob/master/bin/restart.litcoffee)

Restarts an Écrit app with the given `<app name>`.  
If no `<app name>`, assumes current directory.  

#### [`ecrit stop <app name>`](https://github.com/merciba/ecrit/blob/master/bin/stop.litcoffee)

Stops an Écrit app with the given `<app name>`.  
If no `<app name>`, assumes current directory.  

#### [`ecrit test [option]`](https://github.com/merciba/ecrit/blob/master/bin/test.litcoffee)

Runs unit tests for the framework. Currently only `--console` option is supported.

###### TODO

* Finish building out tests
* Design and build out Dashboard features

