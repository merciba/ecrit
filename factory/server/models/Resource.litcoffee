Index Model
==========

	module.exports = {

		identity: 'resource'
		connection: 'mongo'

		attributes: {

			type: {
				type: 'string'
				required: true
			}

			id: {
				type: 'string'
				required: true
				unique: true
			}

			data: {
				type: 'json'
				required: true
			}

			permissions: {
				type: 'string'
				default: 'all'
			} 

			toJSON: () ->
				obj = @toObject()
				return obj
		}
			
	}