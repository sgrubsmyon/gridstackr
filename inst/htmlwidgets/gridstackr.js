HTMLWidgets.widget({

  name: 'gridstackr',

  type: 'output',

  factory: function(el, width, height) {

    // Variables to keep track of the state of the widget
    var grid = null;
    var options = null;

    // Closure
    return {

      renderValue: function(opts) {

        if (grid === null) {
          if (!opts.items) {
            // Defaults - this is inside renderValue as only place where opts appear.  My brain wanted the default initialization outside the closure.
            options = {
              float: true,
              cellHeight: 20,
              verticalMargin: 10,
              animate: true //,
              // height: 10,   // Future:  Put in code to match Shiny container height $('#'+el.id).height()
              // draggable: {  // Use in gridstackrplus
              //   handle: '.chart-title',
              // }
            };
          } else {
            // No data validation yet.
            options = opts.items;
          }

          // Bind grid to child element with grid-stack class and store grid-stack.
          grid = $('#'+el.id).find('.grid-stack').gridstack(options);
        }
        // No updating settings yet
      },

      resize: function(width, height) {
        // No resizing code necessary - gridstack.js handles this.
      },

      // Give access to grid if anyone needs it on the outside
      getGrid: function() {
        return grid;
      }
    };
  }
});

// Helper function to get an existing gridstackr object via the htmlWidgets object.
function getGrid(id){

  // Get the HTMLWidgets object
  var htmlWidgetsObj = HTMLWidgets.find("#" + id);

  var gridstackrObj = null;
  if( typeof(htmlWidgetsObj) !== "undefined"){
    // Use the getChart method we created to get the underlying gridstack
    gridstackrObj = htmlWidgetsObj.getGrid();
  }

  return(gridstackrObj);
}

// Custom handler to add a new widget
Shiny.addCustomMessageHandler('addWidget', function(message) {
  Shiny.unbindAll();
  var $gsitem = getGrid(message.id).append(message.content);
  $gsitem.data('gridstack').addWidget($gsitem.children().last(), x = 0, y = 0, w = 4, h = 4);
  Shiny.bindAll();
});
