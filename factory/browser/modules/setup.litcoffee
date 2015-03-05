Écrit - Setup
=============

	templates = require '../templates/setup'
	window.App = {} if not window.App?

	$.fn.serializeJSON = () ->
		o = {}
		$.each @serializeArray(), () ->
			o[@name] = @value
		o

	window.App.setup = {

		init: () ->
			$(key.split(' ')[1]).on key.split(' ')[0], @methods[method] for key, method of @events

		el: $('[data-module="setup"]')

		events: {
			'click form > button': 'submit'
		}

		methods: {
			submit: (e) ->
				e.preventDefault()
				form = $(@).parent('#setup-form')
				userform = $(@).parent('[data-model="user"]')
				configform = $(@).parent('[data-model="config"]')
				setup = $.post form.attr('action'), { user: userform.serializeJSON(), config: configform.serializeJSON() }
				setup.done (data) ->
					console.log data
		}

	}

	$(document).ready () ->
		window.App.setup.init()
		

