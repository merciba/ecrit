HTTP Post
---------

	module.exports = (app) ->

		return {

			'/setup': [
				app.controllers.users.validate_new_user, 
				app.controllers.global.configure_app_email, 
				app.controllers.global.configure_app_sms, 
				app.controllers.global.set_config, 
				app.controllers.users.send_verify_email, 
				app.controllers.users.send_verify_sms, 
				app.controllers.users.create_new_user,
				(err, user) ->
					if user? and app.isSetup()?
						res.json user
					else	
						res.json { error: "Error during Setup." }, 500
			]

			'/api/:model': [
			
				(req, res, next) ->
					query = {}
					for key, value of app.models[req.params.model].attributes 
						query[key] = req.body[key] if req.body.hasOwnProperty key

					app.models[req.params.model].create query, (err, model) ->
						if err
							res.json { error: err }, 500 
						else
							res.json model
			
			]

		}