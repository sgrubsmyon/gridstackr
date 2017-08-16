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

// ---- Javascript -> Javascript, Javascript -> R

$("document").ready(function() {
  // Send message to R upon widget remove request
  $('.grid-stack').on('click', '.gs-remove-handle', function() {
      var message = {
        gridID: $(this).parents('.gridstackr').attr('id'),
        itemID: $(this).parents('.grid-stack-item').attr('id'),
        nonce: Math.random()
      };
      Shiny.onInputChange("jsRemove", message);
  });

  // Next two events handle minimization and restoration of items.  No need to communicate with R.
  $('.grid-stack').on('click', '.gs-minimize-handle', function() {
    // Get item and gridstack
    var $item = $(this).parents('.grid-stack-item');
    var gstack = getGrid($(this).parents('.gridstackr').attr('id'));
    var $handle = $item.find(".gs-minimize-handle");

    // Save current height and minimize
    $item.attr('data-gs-height-restore', $item.attr('data-gs-height'));
    gstack.data("gridstack").resize($item, width=null, height=2);

    // Modify classes and toggle resizability
    $handle.removeClass("fa-minus").addClass("fa-plus");
    $handle.removeClass("gs-minimize-handle").addClass("gs-restore-handle");
    gstack.data("gridstack").resizable($item, false);
    $item.find(".ui-resizable-handle").css("display", "none");  // resizable() doesn't toggle visibility for some reason
  });

  $('.grid-stack').on('click', '.gs-restore-handle', function() {
    // Get item and gridstack
    var $item = $(this).parents('.grid-stack-item');
    var gstack = getGrid($(this).parents('.gridstackr').attr('id'));
    var $handle = $item.find(".gs-restore-handle");

    // Restore current height and remove attribute
    gstack.data("gridstack").resize($item, width=null, height=parseInt($item.attr('data-gs-height-restore')));
    $item.removeAttr('data-gs-height-restore');

    // Modify classes and toggle resizability
    $handle.removeClass("fa-plus").addClass("fa-minus");
    $handle.removeClass("gs-restore-handle").addClass("gs-minimize-handle");
    gstack.data("gridstack").resizable($item, true);
    $item.find(".ui-resizable-handle").css("display", "block");  // resizable() doesn't toggle visibility for some reason
  });

});
