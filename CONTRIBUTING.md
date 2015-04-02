## Contributing Guidelines

So you want to get started developing Écrit? That's chill, we encourage open source contribution and really believe in the power of collaboration.  

Écrit is aimed at [readability](http://code.tutsplus.com/tutorials/top-15-best-practices-for-writing-super-readable-code--net-8118) and [separation of concerns](http://en.wikipedia.org/wiki/Separation_of_concerns). What do these ideas mean in this context? Mainly, it's reflected in our design decisions.  

#### Literate Coffeescript - Markdown in your code, code in your markdown

[Literate Coffeescript](http://coffeescript.org/#literate) is the matrimonial union of the [CoffeeScript](http://coffeescript.org) parser and [Markdown](http://en.wikipedia.org/wiki/Markdown) syntax.  
Literate Coffescript files use the file extension `.litcoffee`, and can be rendered as Markdown documents (Go ahead, copy any of the source code into a [Markdown parser](http://tmpvar.com/markdown.html)) and as Coffeescript files - in other words, `.litcoffee` renders as `.md` to `.html`, and `.litcoffee` compiles as `.coffee` to `.js`. Say that five times really fast.

Écrit is written almost entirely in Literate Coffeescript, because it means we can generate documentation HTML automatically using [Docco](http://jashkenas.github.io/docco/), and link back to other parts of the code. This means, put as many markdown comments in the code as possible. Link to articles relevant to the subject matter. Explain what's happening here, wherever in the codebase you are. These are the "principes d'Écrit".

#### Loaders Loaders Loaders

Écrit's source code uses a 'loader' pattern, where components are broken out into discrete functions which are loaded dynamically by an expression. As an example, the model/route/controller loaders used in [`factory/server/index.litcoffee`](/factory/server/index.litcoffee) look like this: 

```CoffeeScript
	models[model.replace('.litcoffee', '')] = require("./models/#{model.replace('.litcoffee', '')}") for model in fs.readdirSync(path.join(__dirname, "models"))
	routes[route.replace('.litcoffee', '')] = require("./routes/#{route.replace('.litcoffee', '')}") for route in fs.readdirSync(path.join(__dirname, "routes"))
	controllers[controller.replace('.litcoffee', '')] = require("./controllers/#{controller.replace('.litcoffee', '')}") for controller in fs.readdirSync(path.join(__dirname, "controllers"))
```

What's happening here? Well, note the syntax, which can be boiled down to this: 

```CoffeeScript
	object[filename] = require("path/to/folder/#{filename}") for filename in directory 
```

We're dynamically using Node's `require()` function to load the `module.exports` of each file within a folder, and assign it to a matching named property of an object. This means, we no longer have to worry about how to access stuff between files - put a statement like this in there, and you can add files at will and access them this way, logically grouped into one object. This is a very useful and helpful concept, made possible by Coffeescript's expressive capability. Use it!

#### Indentation

Watch your whitespace. We do tab indents here, 4 spaces wide is my prefence but that's between you and your IDE. Functions are declared like so: 

```CoffeeScript
	foo = () ->
		console.log "I'm inside function foo()"

		bar = () ->
			console.log "I'm inside function bar(), called from within function foo()"

		bar()

	foo() # should see both console.log statements on console 
```

### Project Structure

An Écrit app has the following structure:  

```
[app name]/
	|
	|- browser/
	|	|
	|	|- modules/												# Contains front-end scripts, organized into 'modules' with matching templates
	|	|	|
	|	|	|- setup.litcoffee 									# 'setup' module is prepackaged because you can't have an app unless you configure it
	|	|	|- [module].litcoffee
	|	|
	|	|- templates/											# Contains front-end templates, with matching scripts in the 'modules' folder
	|		|
	|		|- setup.litcoffee 									# templates for the 'setup' module
	|		|- [module].litcoffee
	|
	|	Client Side ("Front End")
----+---------------------------------------------------------
	|	Server Side ("Back End")
	|
	|- config/													# Contains config files for the app
	|	|
	|	|- i18n/												# Internationalization stuff goes here. Define app_i18n_locales in the Setup flow and they'll be added here. 
	|	|	|
	|	|	|- locales/
	|	|		|
	|	|		|-en.json
	|	|		|-[language].json
	|	|
	|	|- passport/											# Passport strategies go in here
	|	|	|
	|	|	|- strategies.litcoffee
	|	|
	|	|- index.litcoffee 										# General app config, mostly for mongoDB and sessions
	|
	|- server/ 													# Contains all the server/api code
	|	|
	|	|- controllers/											# Contains all the controllers
	|	|	|
	|	|	|- global.litcoffee 								# Global controller
	|	|	|- modules.litcoffee 								# Modules controller
	|	|	|- users.litcoffee 									# Users controller
	|	|
	|	|- models/
	|	|	|
	|	|	|- Config.litcoffee 								# Config model
	|	|	|- Module.litcoffee 								# Module model
	|	|	|- Resource.litcoffee 								# Resource model
	|	|	|- User.litcoffee 									# User model
	|	|	
	|	|- public/ 												# Contains static assets.
	|	|	|
	|	|	|- css/
	|	|	|	|
	|	|	|	|- style.css 									# Main CSS file.
	|	|	|
	|	|	|- img/ 											# Contains images
	|	|	|- scripts/ 										# Contains built JS from browser/
	|	|		|
	|	|		|- modules/
	|	|		|	|
	|	|		|	|- setup.js
	|	|		|	|- [module].js
	|	|		|
	|	|		|- templates/
	|	|			|
	|	|			|- setup.js
	|	|			|- [module].js
	|	|	
	|	|- routes/ 												# Express routes for HTTP requests
	|	|	|
	|	|	|- delete.litcoffee 								# HTTP DELETE handler
	|	|	|- get.litcoffee 									# HTTP GET handler
	|	|	|- middleware.litcoffee 							# Express middleware
	|	|	|- post.litcoffee 									# HTTP POST handler
	|	|	|- put.litcoffee 									# HTTP PUT handler
	|	|	
	|	|- views/ 												# Jade views for server-side resources
	|	|	|
	|	|	|- dashboard.jade 									# Dashboard view
	|	|	|- index.jade 										# Homepage view
	|	|	|- layout.jade 										# Layout for the other views
	|	|	|- login.jade 										# Login view
	|	|	|- setup.jade 										# Setup view
	|	|	
	|	|- index.litcoffee 										# Main server script. Everything is setup and invoked from here.
	|	
	|- production.js 											# Production build setup
	|- development.js 											# Development build setup
	|- index.js 												# Main app entrypoint
	|- package.json 											# npm config file, has all dependencies
	|- .gitignore 												# file to specify what Git should ignore

```
