HTTP Put
--------

	module.exports = (app) ->

		return {

			'/api/:model/:id': [(req, res) ->
				delete req.body.id if req.body.id?
				app.models[req.params.model].update { id: req.params.id }, req.body, (err, model) ->
					return res.json { err: err }, 500 if err
					res.json model 
				]

		}