## `test` command handler

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

		for el, i in process.argv
			testOptions[process.argv[i].replace('--', '')] = true if i > 2 and testOptions.hasOwnProperty process.argv[i].replace('--', '')
		
		jsonfile.writeFileSync path.join(__dirname, '../test/config.json'), testOptions

		testTarget = path.join __dirname, '../test'
		
		for folder in fs.readdirSync testTarget
			folderPath = path.join __dirname, "../test/#{folder}"
			if fs.lstatSync(folderPath).isDirectory()
				mocha.addFile path.join(folderPath, file) for file in fs.readdirSync folderPath

Run Mocha tests.

		mocha.run (failures) ->
			process.on 'exit', () ->
				process.exit failures
