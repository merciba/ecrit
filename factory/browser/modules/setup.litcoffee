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
			'click button': 'submit'
		}

		methods: {
			submit: (e) ->
				e.preventDefault()
				form = $(@).parent('#setup-form')
				userform = $(@).siblings('[data-model="user"]')
				configform = $(@).siblings('[data-model="config"]')
				setup = $.post form.attr('action'), { user: userform.serializeJSON(), config: configform.serializeJSON() }
				setup.done (data) ->
					console.log data
					, (err) ->
					console.error err
		}

	}

	$(document).ready () ->
		window.App.setup.init()
		

