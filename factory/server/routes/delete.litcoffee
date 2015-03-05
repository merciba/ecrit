HTTP Delete
-----------

	module.exports = (app) ->

		return {

			'/api/:model/:id': [(req, res) ->
				app.models[req.params.model].destroy { id: req.params.id }, (err) ->
					return res.json { err: err }, 500 if err
					res.json { status: 'ok' } 
				]

		}