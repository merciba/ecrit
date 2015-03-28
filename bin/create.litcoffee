`create` command handler
===

Installs a fresh Écrit project in the target directory.

	fs = require 'fs-sync'
	ncp = require('ncp').ncp
	es = require 'event-stream'
	mkdir = require 'mkdirp'
	path = require('path')
	pkg = require(path.join(__dirname, '../package.json'))
	prompt = require('prompt')
	isEmpty = require 'empty-dir'
	random = require 'random-token'

	module.exports = (end) ->

		prompt.message = 'Écrit'

		folder = if process.argv[3] then process.argv[3] else null

		config = {
			target: if folder then path.join(process.cwd(), folder) else process.cwd()
			randomToken: random 16
		}
		targetExists = fs.exists config.target
		targetEmpty = if targetExists then isEmpty.sync config.target else true

		end 'Écrit: [Error: Target exists and is not empty]'.red if not targetEmpty
		
Prompt the user for initial app and database configuration.

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
					description: 'MongoDB host (optional, Enter to skip)'
					type: 'string'
					default: 'localhost'
				}
				mongo_user: {
					description: 'MongoDB user (optional, Enter to skip)'
					type: 'string'
					pattern: /^[A-Z]+$/i
					message: 'Name must contain only the characters A-Z|a-z'
					default: ''
				}
				mongo_password: {
					description: 'MongoDB password (optional, Enter to skip)'
					type: 'string'
					hidden: true
					default: ''
				}
			}
		}, (err, result) ->
			end err.red if err
			config[key] = value for key, value of result

Create the folder where the app will reside.

			mkdir config.target, (err) ->
				end err.red if err
				console.log "Creating app `#{config.name}` at #{config.target}..."

				options = {
					transform: (read, write) ->
						read = read.pipe(es.replace("<[#{key}]>", value)) for key, value of config
						read = read.pipe(es.replace("factory", config.name))
						read.pipe(write)
				}
				
Copy template from [factory](https://github.com/merciba/ecrit/blob/master/factory) into target folder.

				ncp "#{path.join(__dirname, '../factory')}", config.target, options, (err) ->
					end err.red if err
					end "Done!".green

			
				

