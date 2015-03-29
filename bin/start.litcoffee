`start` command handler
===

	fs = require 'fs-sync'
	es = require 'event-stream'
	path = require 'path'
	exec = require('child_process').exec
	spawn = require('child_process').spawn
	pkg = require(path.join(__dirname, '../package.json'))
	environment = 'development'
	colors = require 'colors'
	rimraf = require 'rimraf'

	module.exports = (end) ->

		if process.env.NODE_ENV
			environment = process.env.NODE_ENV
		else if process.argv[3]?.match('--')
			environment = process.argv[3].replace('--', '')
		else console.warn "[Écrit]".magenta, "[Warning] No environment specified, assuming `development` by default".yellow

		startupScript = path.join process.cwd(), "#{environment}.js"
		node_modules = path.join process.cwd(), "node_modules"

		if not fs.exists node_modules
			install = spawn "npm", ["install"]
			install.stdout.pipe(process.stdout)
			install.stderr.pipe(process.stderr)
			install.on 'close', (code) ->

				if code is 0 and fs.exists startupScript
					require startupScript
					fs = require 'fs'
					server = spawn "node", [startupScript]
					if environment is 'development'
						server.stdout.pipe(process.stdout) 
					if environment is 'production'
						log = fs.createWriteStream(path.join(process.cwd(), 'ecrit.log'))
						server.stdout.pipe(es.replace(/\x1B\[[0-9]*\w/g, '')).pipe(log)
						server.stderr.pipe(es.replace(/\x1B\[[0-9]*\w/g, '')).pipe(log)

				else if fs.exists startupScript
					console.log "System dependencies or permissions have likely caused an interruption in `npm install`.\nNow deleting node_modules/...\n"
					rimraf node_modules, () ->
						end "Run `ecrit start` again after dependencies have been installed to continue."

		else if fs.exists startupScript
			fs = require 'fs'
			server = spawn "node", [startupScript]
			if environment is 'development'
				server.stdout.pipe(process.stdout) 
				server.stderr.pipe(process.stderr)
			if environment is 'production'
				log = fs.createWriteStream(path.join(process.cwd(), 'ecrit.log'))
				server.stdout.pipe(es.replace(/\x1B\[[0-9]*\w/g, '')).pipe(log)
				server.stderr.pipe(es.replace(/\x1B\[[0-9]*\w/g, '')).pipe(log)

		else end "No Écrit project detected in this folder.".red 
