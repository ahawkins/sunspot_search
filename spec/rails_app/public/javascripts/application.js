// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//

$(function(){
  $('.add_condition').click(function(ev){
    ev.preventDefault();

    // store the template html if the user decides
    // to remove all the conditions and start adding again
    if(!$(this).data('templateCondition')) {
      var templateCondition = $('.condition').first().clone();
      $(this).data('templateCondition', templateCondition)
    } else {
      var templateCondition = $(this).data('templateCondition')
    }

    var newIndex = $(".condition").length;

    var newHtml = templateCondition.html().replace(/_\d+_/g, '_' + newIndex + '_'); 
    newHtml = newHtml.replace(/\[\d+\]/g, '[' + newIndex + ']');

    var newCondition = templateCondition.clone();
    newCondition.html(newHtml);


    $(this).parents('fieldset').before(newCondition);

  });

  $('.remove_condition').live('click', function(ev) {
    ev.preventDefault();
    $(this).parents('fieldset').remove();
  });
});
