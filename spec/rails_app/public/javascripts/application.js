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

    // changes the operator select depending on what the attribute is.
    // it also wipes out any modifications to the choices or value html
    // so the new html is clean (laying way for any customer transformations)
    $('select.condition_attribute', form).live('change', function(ev){
      ev.preventDefault();

      // store the original html so remove/add condition works with clean slate
      
      if(!form.data('value-template')) {
        form.data('value-template', $(this).closest('fieldset').find('li.value').clone());
      }

      if(!$(this).data('choices-template')) {
        form.data('choices-template', $(this).closest('fieldset').find('li.choices').clone());
      }

      // hide the choices and operators sections
      $(this).closest('fieldset').find('li.choices').hide();
      $(this).closest('fieldset').find('li.value').hide();

      var selected = $(this).val();
      
      var selectedType = conditions[selected]['type'];

      var options = $.map(attributeOperators[selectedType], function(operator){
        return '<option value="' + operator + '">' + operatorNames[operator] + '</option>'
      });

      // add a blank option so the a change is required to update the UI
      $(this).closest('fieldset').find('select.condition_operator').html('<option></option>' + options.join(' '));
      $(this).closest('fieldset').find('select.condition_operator').parent().show();

      // set the choices select to the related choices
      if(conditions[selected]['choices'] || conditions[selected]['type'] == 'boolean'){
        // now replace the choices and value html with a fresh set for the operators to manipulate
        $(this).closest('fieldset').find('li.choices').replaceWith(form.data('choices-template').clone());

        // the value input should be changed to a select
        var choices = [];

        if(conditions[selected]['type'] == 'boolean') {
          choices.push('<option value="false">' + operatorNames.no + '</option>');
          choices.push('<option value="true">' + operatorNames.yes + '</option>');
        } else {
          for(var choice in conditions[selected]['choices']) {
            choices.push('<option value="' + choice + '">' + conditions[selected]['choices'][choice] + '</option>')
          }
        }

        $(this).closest('fieldset').find('select.choices').html(choices.join(' '));

        $(this).closest('fieldset').find('li.choices').show();
      } else {
        $(this).closest('fieldset').find('li.value').replaceWith(form.data('value-template').clone());
      }
    });

    $('select.condition_operator', form).live('change', function(ev){
      ev.preventDefault();

      var selectedOperator = $(this).val();

      if(selectedOperator == null) return;

      var selectedAttributeKey = $(this).closest('fieldset').find('select.condition_attribute').val();

      var selectedAttribute = conditions[selectedAttributeKey];

      if(selectedAttribute.choices || selectedAttribute.type == 'boolean'){
        // show the select. No transforms allowed.
        $(this).closest('fieldset').find('li.choices').show();
        $(this).closest('fieldset').find('li.value').hide();

        // only show section if the operator needs a value
        if(selectedOperator == 'blank' || selectedOperator == 'not_blank') {
          $(this).closest('fieldset').find('li.value, li.choices').hide();
        }
      } else {
        // ensure a clean slate for the transformations to manipulate
        $(this).closest('fieldset').find('li.value').replaceWith(form.data('value-template').clone());

        // choices should be hidden if the value is not from a predefined set
        $(this).closest('fieldset').find('li.choices').hide();

        // only show section if the operator needs a value
        if(selectedOperator == 'blank' || selectedOperator == 'not_blank') {
          $(this).closest('fieldset').find('li.value, li.choices').hide();
        } else {
          $(this).closest('fieldset').find('li.value').show();

          // now run the transform function for the particular type
          if(config.transforms[selectedAttribute['type']]) {
            // build a list of arguments for the transformation function
            var input = $(this).closest('fieldset').find('li.value input')[0];
            config.transforms[selectedAttribute['type']](input, selectedAttribute, selectedOperator);
          } 
        }
      }
    });
  };
})(jQuery);


$(function(){
  var dateTimeTransform = function(input, condition, operator) {
    if(operator != 'between') {
      $(input).datepicker(); 
    } else {
      // create some HTML for two datepickers
      var baseID = $(input).closest('fieldset').find('li.value input').attr('id');

      var datePickerContainer = $('<div class="dateRangeContainer" />');
      var startLabel = $('<label>Start Date</label>');
      var startDate = $('<input id="' + baseID + '_start_date" />');
      var endLabel = $('<label>End Date</label>');
      var endDate = $('<input id="' + baseID + '_end_date" />');

      datePickerContainer.append(startLabel).append(startDate).append(endLabel).append(endDate);

      $(input).after(datePickerContainer).hide();

      var changeHandler = function() {
        $(input).val(startDate.val() + '--' + endDate.val());
      }

      startDate.datepicker({onSelect: changeHandler});
      endDate.datepicker({onSelect: changeHandler});

      $(input).closest('li').children('label:first-child').text(' ');
    }
  };

  $('form').solrSearch({
  transforms: {
    'date': dateTimeTransform,
    'time': dateTimeTransform,
    'currency': function(input, condition, operator) {
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
        range: operator == 'between',
        slide: function(event, ui) {
          if(operator == 'between') {
            $(sliderContainer).find('label').text('$' + ui.values[0] + ' - ' + '$' + ui.values[1]);
            $(input).val(ui.values[0] + ' - ' + ui.values[1]);
          } else {
            $(sliderContainer).find('label').text('$' + ui.value);
            $(input).val(ui.value);
          }
        }
      });

      $(input).hide();
      $(input).closest('li').children('label:first-child').text(' ');
    }
  }
});
});
