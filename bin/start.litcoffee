## `start` command handler

Starts an Écrit app from within its' working directory.

	fs_sync = require 'fs-sync'
	fs = require 'fs'
	es = require 'event-stream'
	pm2 = require('pm2')
	path = require 'path'
	exec = require('child_process').exec
	spawn = require('child_process').spawn
	pkg = require(path.join(__dirname, '../package.json'))
	colors = require 'colors'
	rimraf = require 'rimraf'

	module.exports = (end) ->

		environment = 'development'

Check to see if there's really an Écrit project here.

		if fs_sync.exists path.join(process.cwd(), 'package.json')
			app_pkg = require(path.join(process.cwd(), 'package.json'))
		else
			end "No package.json found!".red

Detect/assign environment and script paths

		if process.env.NODE_ENV?
			environment = process.env.NODE_ENV
		else if process.argv[3]? and process.argv[3] is ('development' or 'production')
			environment = process.argv[3]
		else console.warn "[Écrit]".magenta, "[Warning] No environment specified, assuming `development` by default".yellow

		startupScript = path.join process.cwd(), "#{environment}.js"
		node_modules = path.join process.cwd(), "node_modules"

Start the app. This function will be invoked later.

		start = () ->

In a development environment, we just spawn a child `node` process using `development.js` and pipe its' output to `process.stdout` (i.e. the Terminal).  
Currently weighing the pros/cons of using `require startupScript` instead.

			if environment is 'development'
				server = spawn "node", [ startupScript ]
				server.stdout.pipe(process.stdout) 
				server.stderr.pipe(process.stderr)

In a production environment, shit gets more real.  

			if environment is 'production'
				exists = false
				options = { name: app_pkg.name, instances: 0 }

First we use PM2 to see what processes are running, if any.

				pm2.connect (err) ->
					end err if err

					pm2.list (err, list) ->
						end err if err
						for proc in list
							if proc.name is path.basename process.cwd()
								exists = true
								procName = proc.name

If there is a process of the same name as this Écrit app, we simply restart it using PM2's famous "0s reload" feature (it really works!).

						if exists is true and procName
							console.log "Instance of #{procName} found, reloading..."
							pm2.reload procName, (err, proc) ->
								end err if err
								pm2.disconnect () ->
									end "Successfully reloaded.".green

If there aren't any matching processes running, we start new one(s).

						else if exists is false
							pm2.start startupScript, options, (err, proc) ->
								end err if err
								pm2.disconnect () ->
									end "Écrit production cluster is up, using max CPU threads.".green

		if fs_sync.exists startupScript
			
Run `npm install` if this is a brand new app.

			if not fs_sync.exists node_modules
				install = spawn "npm", ["install"]
				install.stdout.pipe(process.stdout)
				install.stderr.pipe(process.stderr)
				install.on 'close', (code) ->
					if code is 0
						start()
					else
						console.log "[Écrit]".magenta, "System dependencies or permissions have likely caused an interruption in `npm install`.\nNow deleting node_modules/...\n"
						rimraf node_modules, () ->
							end "Run `ecrit start` again after dependencies have been installed to continue."
			else 
				start()

		else 
			console.log startupScript
			end "No Écrit project detected in this folder.".red 
