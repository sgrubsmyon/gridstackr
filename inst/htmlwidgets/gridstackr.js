HTMLWidgets.widget({

  name: 'gridstackr',

  type: 'output',

  factory: function(el, width, height) {

    // TODO: define shared variables for this instance

    return {

      renderValue: function(x) {

        // TODO: code to render the widget, e.g.
        if (!x.options) {
          var options = {
            float: true,
            cellHeight: 20,
            verticalMargin: 10,
            draggable: {
              handle: '.chart-title',
            }
          };
        } else {
          var options = x.options;
        };

        var grid = $('.grid-stack').gridstack(options);
        // console.log(options);
      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
