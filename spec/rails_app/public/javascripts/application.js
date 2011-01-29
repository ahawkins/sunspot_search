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

    var form = this;

    var conditions = this.data('condition_information');
    var operatorNames = this.data('operators');
    var attributeOperators = this.data('attribute_operators');

    $('.add_condition', form).click(function(ev){
      ev.preventDefault();

      // store the template html if the user decides
      // to remove all the conditions and start adding again
      if(!form.data('templateCondition')) {
        form.data('templateCondition', $('.condition', form).first().clone());
      } 

      var newIndex = $(".condition", form).length;

      var newHtml = form.data('templateCondition').html().replace(/_\d+_/g, '_' + newIndex + '_'); 
      newHtml = newHtml.replace(/\[\d+\]/g, '[' + newIndex + ']');

      var newCondition = form.data('templateCondition').clone();
      newCondition.html(newHtml);

      $(this).parents('fieldset').before(newCondition);
    });

    $('.remove_condition', form).live('click', function(ev) {
      ev.preventDefault();
      // destroy the datpicker if present
      $(this).closest('fieldset').find('li.value input').datepicker('destroy');
      $(this).closest('fieldset').remove();
    });

    $('select.condition_attribute', form).live('change', function(ev){
      ev.preventDefault();

      // store the original html so remove/add condition works with clean slate
      
      if(!form.data('value-template')) {
        form.data('value-template', $(this).closest('fieldset').find('li.value').clone());
      }

      if(!$(this).data('choices-template')) {
        form.data('choices-template', $(this).closest('fieldset').find('li.choices').clone());
      }

      var selected = $(this).val();
      
      var selectedType = conditions[selected]['type'];

      var options = $.map(attributeOperators[selectedType], function(operator){
        return '<option value="' + operator + '">' + operatorNames[operator] + '</option>'
      });

      $(this).closest('fieldset').find('select.condition_operator').html(options.join(' '));

      if(conditions[selected]['choices']){
        // replace the html with a fresh clone
        
        $(this).closest('fieldset').find('li.choices').replaceWith(form.data('choices-template').clone());

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

        // replace the value html with a fresh copy
        $(this).closest('fieldset').find('li.value').replaceWith(form.data('value-template').clone());

        $(this).closest('fieldset').find('select.choices').html('<option></option>');
        $(this).closest('fieldset').find('li.choices').hide();
        $(this).closest('fieldset').find('li.value').show();

        // now run the transform function for the particular type
        
        if(config.transforms[selectedType]) {
          config.transforms[selectedType]($(this).closest('fieldset').find('li.value input')[0], conditions[selected]);
        }
      }
    });
  };
})(jQuery);


$(function(){
  $('form').solrSearch({
    transforms: {
      'date': function(input) { $(input).datepicker(); },
      'date_time': function(input) { $(input).datepicker(); },
      'currency': function(input, condition) {
        // only want to make one condition a slider
        var sliderContainer  = $('<div class="sliderContainer"/>');
        var sliderLabel = $('<label>Amount $<span>1000</span>');
        var slider = $('<div class="slider" />');

        sliderContainer.prepend(sliderLabel).append(slider);
        $(input).parent().addClass('slider');
        $(input).after(sliderContainer).hide();
        $(sliderLabel).text('$1000');
        $(slider).slider({
          max: condition.extras.max, 
          min: condition.extras.min, 
          step: condition.extras.step,
          slide: function(event, ui) {
            $(sliderContainer).find('label').text('$' + ui.value);
            $(input).val(ui.value);
          }
        });

        $(input).hide();
        $(input).closest('li').children('label:first-child').text(' ');
      }
    }
  });
});
