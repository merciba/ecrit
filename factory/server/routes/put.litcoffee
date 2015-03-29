HTTP Put
--------

	module.exports = (app) ->

		update_resource = (req, res) ->
			delete req.body.id if req.body.id?
			
			app.models.resource.update { type: req.params.type, id: req.params.id }, { data: req.body.data }, (err, result) ->
				if err
					res.json { err: err }, 500 
				else
					res.json result

		return {

			'/api/:type/:id': [ update_resource ]

		}