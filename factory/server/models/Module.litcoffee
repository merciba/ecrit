Module Model
============

	fs = require 'fs'
	path = require 'path'

	module.exports = {

		identity: 'modules'
		connection: 'mongo'

		attributes: {

			name: {
				type: 'string'
				required: true
			}

			script: {
				type: 'string'
				required: true
			}

			templates: {
				type: 'string'
				required: true
			}

			toJSON: () ->
				return @toObject()

		}
			
	}