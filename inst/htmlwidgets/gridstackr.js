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
          options = opts.items;

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
function getGrid(id) {

  // Get the HTMLWidgets object
  var htmlWidgetsObj = HTMLWidgets.find("#" + id);

  var gridstackrObj = null;
  if( typeof(htmlWidgetsObj) !== "undefined"){
    // Use the getChart method we created to get the underlying gridstack
    gridstackrObj = htmlWidgetsObj.getGrid();
  }

  return(gridstackrObj);
}

// ---- R -> Javascript

// Custom handler to add a new widget
Shiny.addCustomMessageHandler('addWidget', function(message) {
  var $gsitem = getGrid(message.gridID).append(message.content);
  $gsitem.data('gridstack').addWidget($gsitem.children().last(), x = 0, y = 0, minWidth = 4, minHeight = 10, autoPosition = true);
  if (message.itemID) {
    $gsitem.children().last().attr('id', message.itemID);
  }
});

// Custom handler to remove a widget
Shiny.addCustomMessageHandler('removeWidget', function(message) {
  // Do I need unbindAll/bindAll???
  Shiny.unbindAll();
  var $gsitem = getGrid(message.gridID);
  $gsitem.data('gridstack').removeWidget($('#'+message.itemID));
  Shiny.bindAll();
});

// ---- Javascript -> R

// Send message to R upon widget remove request
$("document").ready(function() {
  $('.grid-stack').on('click', '.gs-remove-handle', function() {
      var message = {
        gridID: $(this).parents('.gridstackr').attr('id'),
        itemID: $(this).parents('.grid-stack-item').attr('id'),
        nonce: Math.random()
      };
      Shiny.onInputChange("jsRemove", message);
  });
});
