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
	|	|- modules/
	|	|	|
	|	|	|- setup.litcoffee
	|	|	|- [module].litcoffee
	|	|
	|	|- templates/
	|		|
	|		|- setup.litcoffee
	|		|- [module].litcoffee
	|
	|	Client Side ("Front End")
----+---------------------------------------------------------
	|	Server Side ("Back End")
	|
	|- config/
	|	|
	|	|- i18n/
	|	|	|
	|	|	|- locales/
	|	|		|
	|	|		|-en.json
	|	|		|-[language].json
	|	|
	|	|- passport/
	|	|	|
	|	|	|- strategies.litcoffee
	|	|
	|	|- index.litcoffee
	|
	|- server/
	|	|
	|	|- controllers/
	|	|- models/
	|	|- public/
	|	|- routes/
	|	|- views/
	|	|- index.litcoffee
	|	
	|- production.js
	|- development.js
	|- index.js
	|- package.json
	|- .gitignore

```
