## `show` command handler

	fs_sync = require 'fs-sync'
	fs = require 'fs'
	es = require 'event-stream'
	pm2 = require 'pm2'
	path = require 'path'
	exec = require('child_process').exec
	spawn = require('child_process').spawn
	pkg = require(path.join(__dirname, '../package.json'))
	colors = require 'colors'
	moment = require 'moment'
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
					pm2.describe app_name, (err, proc) ->
						end err if err
						pm2.disconnect () ->
							status = if proc[0].pm2_env.status is 'online' then proc[0].pm2_env.status.green else proc[0].pm2_env.status.red
							end "\n ====================================\n
								#{app_name.magenta}\n
								------------------------------------\n
								Instances: #{proc[0].pm2_env.instances}\n
								Last Started: #{moment(proc[0].pm2_env.created_at).fromNow()}\n
								Status: #{status}\n
								===================================="

If there aren't any matching processes running, end with error.

				if exists is false
					pm2.disconnect () ->
						end "[Error] No app by the name of `#{app_name}` running.".red