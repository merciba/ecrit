(function() {
  var templates;

  templates = require('../templates/setup');

  if (window.App == null) {
    window.App = {};
  }

  $.fn.serializeJSON = function() {
    var o;
    o = {};
    $.each(this.serializeArray(), function() {
      return o[this.name] = this.value;
    });
    return o;
  };

  window.App.setup = {
    init: function() {
      var key, method, ref, results;
      ref = this.events;
      results = [];
      for (key in ref) {
        method = ref[key];
        results.push($(key.split(' ')[1]).on(key.split(' ')[0], this.methods[method]));
      }
      return results;
    },
    el: $('[data-module="setup"]'),
    events: {
      'click button': 'submit'
    },
    methods: {
      submit: function(e) {
        var configform, form, setup, userform;
        e.preventDefault();
        form = $(this).parent('#setup-form');
        userform = $(this).siblings('[data-model="user"]');
        configform = $(this).siblings('[data-model="config"]');
        setup = $.post(form.attr('action'), {
          user: userform.serializeJSON(),
          config: configform.serializeJSON()
        });
        return setup.done(function(data) {
          console.log(data, function(err) {});
          return console.error(err);
        });
      }
    }
  };

  $(document).ready(function() {
    return window.App.setup.init();
  });

}).call(this);
