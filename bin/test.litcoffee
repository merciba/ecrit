`test` command handler
===

	fs = require 'fs-sync'
	path = require 'path'
	exec = require('child_process').exec
	spawn = require('child_process').spawn
	pkg = require(path.join(__dirname, '../package.json'))
	jsonfile = require 'jsonfile'
	testOptions = {
		console: false
	}

	module.exports = (end) ->

		if not fs.exists path.join(__dirname, '../factory/node_modules')
			factory = path.join(__dirname, '../factory')
			console.log "Installing NPM Modules for /factory..."
			exec("cd #{factory} && npm install")
			console.log "Successfully installed NPM Modules in /factory/node_modules".green

		for el, i in process.argv
			testOptions[process.argv[i].replace('--', '')] = true if i > 2 and testOptions.hasOwnProperty process.argv[i].replace('--', '')
		
		jsonfile.writeFileSync path.join(__dirname, '../test/config.json'), testOptions

		testTarget = path.join(__dirname, '../test/**/*litcoffee')
		test = spawn("./node_modules/mocha/bin/mocha", ["--compilers", "coffee:coffee-script/register", testTarget])
		test.stdout.pipe(process.stdout)
		test.stderr.pipe(process.stderr)
		test.on 'close', (code) ->
			if code is 0 
				end "Test Complete!"
			else
				end "Testing Error."
