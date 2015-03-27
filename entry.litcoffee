Écrit CLI
=========

The CLI interface for the Écrit publishing framework.

	fs = require 'fs-sync'
	path = require('path')
	pkg = require(path.join(__dirname, 'package.json'))
	exec = require('child_process').exec
	spawn = require('child_process').spawn
	prompt = require('prompt')
	isEmpty = require 'empty-dir'
	random = require 'random-token'
	install = require './install'

	prompt.message = 'Écrit'
	folder = if process.argv[3] then process.argv[3] else null

	config = {
		target: if folder then path.join(process.cwd(), folder) else process.cwd()
		randomToken: random 16
	}
	targetExists = fs.exists config.target
	targetEmpty = if targetExists then isEmpty.sync config.target else true

	done = (exitmsg) ->
		console.log exitmsg if exitmsg
		process.exit 0

	switch process.argv[2]
		when 'create'
			done 'Écrit: [Error: Target exists and is not empty]'.red if not targetEmpty
			prompt.get { 
				properties: {
					name: {
						description: 'Name of your new app'
						type: 'string'
						pattern: /^[A-Z]+$/i
						message: 'Name must contain only the characters A-Z|a-z'
						default: path.basename config.target
						required: true
					}
					mongo_host: {
						description: 'MongoDB host'
						type: 'string'
						default: 'localhost'
					}
					mongo_user: {
						description: 'MongoDB user'
						type: 'string'
						pattern: /^[A-Z]+$/i
						message: 'Name must contain only the characters A-Z|a-z'
						default: ''
					}
					mongo_password: {
						description: 'MongoDB password'
						type: 'string'
						hidden: true
						default: ''
					}
				}
			}, (err, result) ->
				done err.red if err
				config[key] = value for key, value of result
				install config, done

		when 'test'
			if not fs.exists path.join(__dirname, 'factory/node_modules')
				factory = path.join(__dirname, 'factory')
				console.log "Installing NPM Modules for /factory..."
				exec("cd #{factory} && npm install")
				console.log "Successfully installed NPM Modules in /factory/node_modules".green

			testTarget = path.join(__dirname, 'test/**/*litcoffee')
			test = spawn("mocha", ["--compilers", "coffee:coffee-script/register", testTarget])
			test.stdout.pipe(process.stdout)
			test.stderr.pipe(process.stderr)

		else console.log "Not a valid parameter. \n\t`ecrit [create] [directory]`"
