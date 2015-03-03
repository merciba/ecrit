Install
=======

Installs a fresh Écrit project in the target directory.

	fs = require 'fs'
	ncp = require('ncp').ncp
	es = require 'event-stream'
	mkdir = require 'mkdirp'

	module.exports = (config, end) ->
		console.log config

		mkdir config.target, (err) ->
			end err.red if err
			console.log "Installing project #{config.name} at #{config.target}".magenta

			options = {
				transform: (read, write) ->
					read = read.pipe(es.replace("<[#{key}]>", value)) for key, value of config
					read.pipe(write)
			}
			
			ncp "#{__dirname}/templates/#{config.template}/", config.target, options, (err) ->
				end err.red if err
				end "Done!".green

			
				

