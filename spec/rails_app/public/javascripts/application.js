// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//

(function($){
  $.fn.solrSearch = function(options){

    var toDatePicker = function(element) {
      $(element).datepicker();
    };

    var defaults = {
      transforms: {
        'date': toDatePicker,
        'date_time': toDatePicker
      }
    };

    var config = $.extend(defaults, options);

    $(this).data('solrSearch-config', config);

    $('.add_condition', this).click(function(ev){
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

    $('.remove_condition', this).live('click', function(ev) {
      ev.preventDefault();
      // destroy the datpicker if present
      $(this).closest('fieldset').find('li.value input').datepicker('destroy');
      $(this).closest('fieldset').remove();
    });

    $('select.condition_attribute', this).live('change', function(ev){
      ev.preventDefault();

      var selected = $(this).val();

      var conditions = $('form').data('condition_information');
      var operatorNames = $('form').data('operators');
      var attributeOperators = $('form').data('attribute_operators');
      
      var selectedType = conditions[selected]['type'];

      var options = $.map(attributeOperators[selectedType], function(operator){
        return '<option value="' + operator + '">' + operatorNames[operator] + '</option>'
      });

      $(this).closest('fieldset').find('select.condition_operator').html(options.join(' '));

      if(conditions[selected]['choices']){
        // the value input should be changed to a select
        var choices = [];

        for(var choice in conditions[selected]['choices']) {
          choices.push('<option value="' + choice + '">' + conditions[selected]['choices'][choice] + '</option>')
        }

        $(this).closest('fieldset').find('select.choices').html(choices.join(' '));
        $(this).closest('fieldset').find('li.choices').show();
        $(this).closest('fieldset').find('li.value').hide();
      } else {
        // the value input should be changed to a textbox
        // and there should be no options in the choices select

        $(this).closest('fieldset').find('select.choices').html('<option></option>');
        $(this).closest('fieldset').find('li.choices').hide();
        $(this).closest('fieldset').find('li.value').show();

        // now run the transform function for the particular type
        
        if(config.transforms[selectedType]) {
          config.transforms[selectedType]($(this).closest('fieldset').find('li.value input')[0]);
        }
      }
    });
  };
})(jQuery);


$(function(){
  $('form').solrSearch();
});
