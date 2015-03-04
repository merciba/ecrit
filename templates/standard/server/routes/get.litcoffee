HTTP Get
--------

	module.exports = (app) ->

		return {

			'/': [(req, res) ->
				if app.isSetup?
					res.render 'index', { 
						title : 'Écrit'
						description: res.__ 'Publishing for cool people'
					}
				else res.redirect '/setup'
				]

			'/login': [(req, res) ->
				res.render 'login', { 
					title : 'Écrit'
					description: res.__ 'Login'
					require: ['login']
				}
				]

			'/setup': [(req, res) ->
				res.render 'setup', { 
					title : 'Écrit'
					description: res.__ 'Setup'
					require: ['setup']
				}
				]

			'/dashboard': [(req, res) ->
				res.render 'dashboard', { 
					title : 'Écrit'
					description: res.__ 'Dashboard'
					require: ['dashboard']
				}
				]

			'/verify/:token': [ app.controllers.auth.verify_token ]

			'/:model': [(req, res) ->
				if req.params.model.match /(admin|wp-admin|signin|login|home)/
					res.redirect '/dashboard'
				else
					query = { id: req.params.id }

					app.models[req.params.model].findOne query, (err, model) ->
						res.redirect '/404' if err
						res.render req.params.model, model
				]

			'/:model/:id': [(req, res) ->
				query = { id: req.params.id }

				app.models[req.params.model].findOne query, (err, model) ->
					res.redirect '/404' if err
					res.render req.params.model, model
				]

			'/api/:model': [(req, res) ->

				app.models[req.params.model].find().exec (err, models) ->
					return res.json { err: err }, 500 if err
					res.json models
				]

			'/api/:model/:id': [(req, res) ->
				query = { id: req.params.id }

				app.models[req.params.model].findOne query, (err, model) ->
					return res.json { err: err }, 500 if err
					res.json model
				]

		}