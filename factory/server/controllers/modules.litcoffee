### Modules Controller

	fs = require 'fs'
	path = require 'path'
	Readable = require('stream').Readable

	class StringStream extends Readable
		constructor: (@str) ->
			super()

		_read: (size) ->
			@push @str
			@push null

	writeScriptFile = (module, next) ->
		scriptPath = path.join __dirname, "../../browser/modules/#{module.name}.litcoffee"
		script = fs.createWriteStream scriptPath
		scriptString = new StringStream module.script

		script.on 'finish', (err) ->
			app.error err if err
			next()
		
		scriptString.pipe script

	writeTemplatesFile = (module, next) ->
		templatesPath = path.join __dirname, "../../browser/templates/#{module.name}.litcoffee"
		templates = fs.createWriteStream templatesPath
		templatesString = new StringStream module.templates

		templates.on 'finish', (err) ->
			app.error err if err
			next()
		
		templatesString.pipe templates


	module.exports = (app) ->

		return {

#### sync_modules

Syncs modules to the filesystem. This happens once per request to the frontend JS, placed before the response.

			sync_modules: (req, res, next) ->
				app.models.modules.find {}, (err, modules) ->
					if err
						app.error err
					
					for module in modules
						writeScriptFile module, () ->
							writeTemplatesFile module, next	
						
#### create_module

Creates a module in the db. `sync_modules` is called after this.

			create_module: (req, res, next) ->
				if req.body.module?
					query = {}
					for key, value of app.models.modules.attributes 
						query[key] = req.body.module[key] if req.body.module.hasOwnProperty key

					app.models.modules.create query, (err, module) ->
						if err
							res.status(500).json { error: err }
						else
							writeScriptFile module, () ->
								writeTemplatesFile module, next
				else
					res.status(500).json { error: err }

#### update_module

Updates a particular module in the db.

			update_module: (req, res, next) ->
				if req.body.module?
					query = { name: req.body.module.name }

					app.models.modules.update query, req.body.module, (err, module) ->
						if err
							res.status(500).json { error: err }
						else
							writeScriptFile module, () ->
								writeTemplatesFile module, next
				else
					res.status(500).json { error: err }

		}