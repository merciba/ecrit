HTTP Post
---------

	module.exports = (app) ->

		create_resource = (req, res) ->
			query = { type: req.params.type, id: req.body.id, data: req.body.data, permissions: req.body.permissions }

			app.models.resource.create query, (err, result) ->
				if err
					res.json { error: err }, 500 
				else
					res.json result

		return {

			'/setup': [
				app.controllers.users.validate_new_user, 
				app.controllers.global.configure_app_email, 
				app.controllers.global.configure_app_sms, 
				app.controllers.global.set_config, 
				app.controllers.users.send_verify_email, 
				app.controllers.users.send_verify_sms, 
				app.controllers.users.create_new_user,
				(req, res) ->
					if req.user? and app.isSetup()
						res.json req.user
					else
						res.json { error: "Error during Setup." }, 500
			]

			'/api/:type': [
				app.controllers.global.configured,
				create_resource 
			]

		}