`start` command handler
===

	fs = require 'fs-sync'
	path = require 'path'
	exec = require('child_process').exec
	spawn = require('child_process').spawn
	pkg = require(path.join(__dirname, '../package.json'))
	environment = 'development'
	colors = require 'colors'
	badge = " ==================================================================\n
			|\t\t\t\t.|||.                             |\n
			|\t\t\t\t| | |                             |\n
			|\t\t\t\t| | |                             |\n
			|\t\t\t\t| | |                             |\n
			|\t\t\t\t| O |                             |\n
			|\t\t\t\t|   |                             |\n
			|\t\t\t\t|___|                             |\n
			|\t\t\t\t(   )                             |\n
			|\tÉcrit\t\t\t|   |                             |\n
			|\t------------------------|   |                             |\n
			|\t   ---------------------|   |   An extremely              |\n
			|\t      ------------------|   |   opinionated               |\n
			|\t\t ---------------|   |   app framework.            |\n
			|\t\t    ------------'.-.'                             |\n
			|\t\t       --------- ) (                              |\n
			|\t\t\t  ------(   )                             |\n
			|\t\t\t     --- \\|/                              |\n
			|\t\t\t\t  '                               |\n
			==================================================================".magenta

	module.exports = (end) ->

		if process.env.NODE_ENV
			environment = process.env.NODE_ENV
		else if process.argv[3]?.match('--')
			environment = process.argv[3].replace('--', '')
		else console.warn "[Écrit]".magenta, "[warning] No environment specified, assuming `development` by default".yellow

		startupScript = path.join process.cwd(), "#{environment}.js"
		node_modules = path.join process.cwd(), "node_modules"

		if not fs.exists node_modules
			install = spawn "npm", ["install"]
			install.stdout.pipe(process.stdout)
			install.stderr.pipe(process.stderr)
			install.on 'close', (code) ->
				if code is 0 and fs.exists startupScript
					console.log badge
					require startupScript
		else if fs.exists startupScript
			console.log badge
			require startupScript
		else end "No Écrit project detected in this folder.".red 
