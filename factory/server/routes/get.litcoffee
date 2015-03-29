HTTP Get
--------

	module.exports = (app) ->

		return {

			'/': [
				app.controllers.global.configured,
				(req, res) ->
					res.render app.config.app_name, { 
						title : 'Écrit'
						description: app.__ 'Publishing for cool people'
					}
			]

			'/login': [
				app.controllers.global.configured,
				(req, res) ->
					res.render 'login', { 
						title : app.config.app_name
						description: app.__ 'Login'
						require: ['login']
					}
			]

			'/setup': [
				(req, res) ->
					res.render 'setup', { 
						title : 'Écrit'
						description: app.__ 'Setup'
						app_name: app.data_config.app_id
						require: ['setup']
					}
			]

			'/dashboard': [
				app.controllers.global.configured,
				(req, res) ->
					res.render 'dashboard', { 
						title : 'Écrit'
						description: app.__ 'Dashboard'
						require: ['dashboard']
					}
			]

			'/verify/:token': [ 
				app.controllers.global.configured,
				app.controllers.users.verify_token, 
				(req, res) ->
					res.render 'dashboard', { 
						title : 'Écrit'
						description: app.__ 'Dashboard'
						require: ['dashboard']
					}
			]

			'/:type': [
				app.controllers.global.configured,
				(req, res) ->
					if req.params.type.match /(admin|wp-admin|home)/
						res.redirect '/dashboard'
					else
						query = { type: req.params.type }

						app.models.resource.find query, (err, results) ->
							if err
								res.redirect '/404' 
							else
								res.render req.params.type, {
									title: app.config.app_name
									data: results
								}
			]

			'/:type/:id': [
				app.controllers.global.configured,
				(req, res) ->
					query = { type: req.params.type, id: req.params.id }

					app.models.resource.findOne query, (err, result) ->
						if err
							res.redirect '/404' 
						else 
							res.render req.params.type, result
			]

			'/api/:type': [
				app.controllers.global.configured,
				(req, res) ->
					app.models.resource.find({ type: req.params.type }).exec (err, results) ->
						if err
							res.json { err: err }, 500 
						else 
							res.json results
			]

			'/api/:type/:id': [
				app.controllers.global.configured,
				(req, res) ->
					query = { type: req.params.type, id: req.params.id }

					app.models.resource.findOne query, (err, result) ->
						if err 
							res.json { err: err }, 500
						else
							res.json result
			]

		}