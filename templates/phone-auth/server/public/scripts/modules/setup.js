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
      'click #signup-btn': 'signup'
    },
    methods: {
      signup: function(e) {
        var form, setup;
        e.preventDefault();
        form = $(this).parent();
        setup = $.post('/setup', form.serializeJSON());
        return setup.done(function(data) {
          console.log(data);
          if (data.error != null) {
            return toastr.error(data.error);
          }
        });
      }
    }
  };

  $(document).ready(function() {
    return window.App.setup.init();
  });

}).call(this);
