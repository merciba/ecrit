`test` command handler
===

	fs = require 'fs'
	fs_sync = require 'fs-sync'
	path = require 'path'
	exec = require('child_process').exec
	spawn = require('child_process').spawn
	pkg = require(path.join(__dirname, '../package.json'))
	jsonfile = require 'jsonfile'
	Mocha = require 'mocha'
	mocha = new Mocha
	testOptions = {
		console: false
	}

	module.exports = (end) ->

		if not fs_sync.exists path.join(__dirname, '../factory/node_modules')
			factory = path.join(__dirname, '../factory')
			console.log "Installing NPM Modules for /factory..."
			exec("cd #{factory} && npm install")
			console.log "Successfully installed NPM Modules in /factory/node_modules".green

		for el, i in process.argv
			testOptions[process.argv[i].replace('--', '')] = true if i > 2 and testOptions.hasOwnProperty process.argv[i].replace('--', '')
		
		jsonfile.writeFileSync path.join(__dirname, '../test/config.json'), testOptions

		testTarget = path.join __dirname, '../test'
		
		for folder in fs.readdirSync testTarget
			folderPath = path.join __dirname, "../test/#{folder}"
			if fs.lstatSync(folderPath).isDirectory()
				mocha.addFile path.join(folderPath, file) for file in fs.readdirSync folderPath

		mocha.run (failures) ->
		  process.on 'exit', () ->
		    process.exit failures
