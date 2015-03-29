HTTP Delete
-----------

	module.exports = (app) ->

		delete_resource = (req, res) ->
			
			app.models.resource.destroy { type: req.params.type, id: req.params.id }, (err) ->
				if err
					res.json { err: err }, 500 
				else
					res.json { status: 'ok' }

		return {

			'/api/:type/:id': [ delete_resource ]

		}