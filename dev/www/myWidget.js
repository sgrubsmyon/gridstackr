$(document).ready(function() {
  $('.grid-stack').on('click', '.gs-remove-handle', function() {
    var el = $(this).parents('.grid-stack-item');
    el.fadeOut(200, function(){
      $('.grid-stack').data('gridstack').removeWidget(el, true);
    });
  });
});
