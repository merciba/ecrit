`test` command handler
===

	fs = require 'fs-sync'
	path = require 'path'
	exec = require('child_process').exec
	spawn = require('child_process').spawn
	pkg = require(path.join(__dirname, '../package.json'))

	module.exports = (end) ->

		if not fs.exists path.join(__dirname, '../factory/node_modules')
			factory = path.join(__dirname, '../factory')
			console.log "Installing NPM Modules for /factory..."
			exec("cd #{factory} && npm install")
			console.log "Successfully installed NPM Modules in /factory/node_modules".green

		testTarget = path.join(__dirname, '../test/**/*litcoffee')
		test = spawn("mocha", ["--compilers", "coffee:coffee-script/register", testTarget])
		test.stdout.pipe(process.stdout)
		test.stderr.pipe(process.stderr)
