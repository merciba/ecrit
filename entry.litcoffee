Écrit CLI
=========

The CLI interface for the Écrit publishing framework.

	fs = require 'fs-sync'
	path = require('path')
	pkg = require(path.join(__dirname, 'package.json'))
	exec = require('exec')
	prompt = require('prompt')
	isEmpty = require 'empty-dir'
	random = require 'random-token'
	install = require './install'

	prompt.message = 'Écrit'
	folder = if process.argv[3] then process.argv[3] else null

	config = {
		target: if folder then path.join(process.cwd(), folder) else process.cwd()
		randomToken: random 16
	}
	targetExists = fs.exists config.target
	targetEmpty = if targetExists then isEmpty.sync config.target else true

	done = (exitmsg) ->
		console.log exitmsg if exitmsg
		process.exit 0

	done 'Écrit: [Error: Target exists and is not empty]'.red if not targetEmpty

	switch process.argv[2]
		when 'create'
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
					template: {
						description: 'Template to use'
						type: 'string'
						pattern: /(phone-auth|standard)/i
						message: 'Must enter a valid template name.'
						default: 'standard'
					}
					mongo_host: {
						description: 'MongoDB host'
						type: 'string'
						default: 'localhost'
					}
					mongo_user: {
						description: 'MongoDB user'
						type: 'string'
						pattern: /^[A-Z]+$/i
						message: 'Name must contain only the characters A-Z|a-z'
						default: ''
					}
					mongo_password: {
						description: 'MongoDB password'
						type: 'string'
						hidden: true
						default: ''
					}
				}
			}, (err, result) ->
				done err.red if err
				config[key] = value for key, value of result
				switch config.template
					when 'phone-auth'
						prompt.get { 
							properties: {
								twilio_sid: {
									description: 'Twilio Account SID'
									type: 'string'
									required: true
									message: 'You must supply Twilio auth credentials to use this template.'
									default: ''
								}
								twilio_auth_token: {
									description: 'Twilio Auth Token'
									type: 'string'
									message: 'You must supply Twilio auth credentials to use this template.'
									required: true
									default: ''
								}
							}
						}, (err, result) ->
							done err.red if err
							config[key] = value for key, value of result
							install config, done
					when 'standard'
						install config, done

		else console.log "Not a valid parameter. \n\t`ecrit [create] [directory]`"
