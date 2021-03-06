## `stop` command handler

	fs_sync = require 'fs-sync'
	fs = require 'fs'
	es = require 'event-stream'
	pm2 = require 'pm2'
	path = require 'path'
	exec = require('child_process').exec
	spawn = require('child_process').spawn
	pkg = require(path.join(__dirname, '../package.json'))
	colors = require 'colors'
	rimraf = require 'rimraf'

	module.exports = (end) ->

		app_name = path.basename process.cwd()
		
		if fs_sync.exists path.join(process.cwd(), 'package.json')
			app_pkg = require(path.join(process.cwd(), 'package.json'))
			app_name = app_pkg.name
		
		app_name = process.argv[3] if process.argv[3]
		exists = false

First we use PM2 to see if the named app is running.

		pm2.connect (err) ->
			end err if err

			pm2.list (err, list) ->
				end err if err
				for proc in list
					exists = true if proc.name is app_name
				
				if exists is true
					console.log "Instance of #{app_name} found, stopping..."
					pm2.stop app_name, (err, proc) ->
						end err if err
						pm2.disconnect () ->
							end "Successfully stopped all instances of `#{app_name}`. Run `ecrit start #{app_name}` to get it back up.".green

If there aren't any matching processes running, end with error.

				if exists is false
					pm2.disconnect () ->
						end "[Error] No app by the name of `#{app_name}` running.".red