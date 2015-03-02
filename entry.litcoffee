Écrit CLI
=========

The CLI interface for the Écrit publishing framework.

	fs = require 'fs-sync'
	path = require('path')
	pkg = require(path.join(__dirname, 'package.json'))
	exec = require('exec')
	prompt = require('prompt')
	isEmpty = require 'empty-dir'
	install = require './install'

	prompt.message = 'Écrit'
	
	config = {
		target: if process.argv[3] then path.join(process.cwd(), process.argv[3]) else process.cwd()
	}
	targetExists = fs.exists config.target
	targetEmpty = if targetExists then isEmpty.sync config.target else true

	done = (exitmsg) ->
		console.log exitmsg if exitmsg
		process.exit 0

	done 'Error: Target exists and is not empty' if not targetEmpty

	switch process.argv[2]
		when 'create'
			prompt.get { 
				properties: {
					name: {
						description: 'Name of your new app'
						type: 'string'
						pattern: /^[A-Z]+$/i
						message: 'Name must contain only the characters A-Z|a-z'
						required: true
					}
					template: {
						description: 'Template to use'
						type: 'string'
						pattern: /(phone-auth|standard)/i
						message: 'Must enter a valid template name.'
						default: 'standard'
					}
					mongo_url: {
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
				console.log err if err
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
							console.log err if err
							config[key] = value for key, value of result
							install config, done
					when 'standard'
						install config, done

		else console.log "Not a valid parameter. \n\t`ecrit [create] [directory]`"
