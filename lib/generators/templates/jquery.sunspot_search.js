(function($){
  $.fn.solrSearch = function(options){
    var defaults = {transforms: {}};

    var config = $.extend(options, defaults);

    $(this).data('solrSearch-config', config);

    var form = this;

    var conditions = this.data('condition_information');
    var operatorNames = this.data('operators');
    var attributeOperators = this.data('attribute_operators');

    // store the template html if the user decides
    // to remove all the conditions and start adding again
    // Store it before the form is manipulated so the HTML
    // is always at a fresh state
    form.data('templateCondition', $('.condition:last', form).first().clone());

    $('.add_condition', form).click(function(ev){
      ev.preventDefault();
      if(!form.data('numberConditions')) {
        form.data('numberConditions', $('.condition', form).length);
      }

      var newIndex = form.data('numberConditions') + 1;

      var newHtml = form.data('templateCondition').html().replace(/_\d+_/g, '_' + newIndex + '_'); 
      newHtml = newHtml.replace(/\[\d+\]/g, '[' + newIndex + ']');

      var newCondition = form.data('templateCondition').clone();
      newCondition.html(newHtml);

      $(this).parents('fieldset').before(newCondition);

      // set the increment the counter so we never have an in collosion
      form.data('numberConditions', newIndex + 1);
    });

    $('.remove_condition', form).live('click', function(ev) {
      ev.preventDefault();

      $(this).closest('fieldset').remove();
    });

    // changes the operator select depending on what the attribute is.
    // it also wipes out any modifications to the choices or value html
    // so the new html is clean (laying way for any customer transformations)
    $('select.condition_attribute', form).live('change', function(ev){
      ev.preventDefault();

      // don't do anything if it's blank
      if($(this).val() == null || $(this).val() == '') { return; }

      var fieldset = $(this).closest('fieldset');

      // store the original html so remove/add condition works with clean slate
      if(!fieldset.data('value-template')) {
        fieldset.data('value-template', fieldset.find('li.value').clone());
      }

      if(!fieldset.data('choices-template')) {
        fieldset.data('choices-template', fieldset.find('li.choices').clone());
      }

      // hide the choices and operators sections
      fieldset.find('li.choices').hide();
      fieldset.find('li.value').hide();

      var selected = $(this).val();
      
      var selectedType = conditions[selected]['type'];

      if(conditions[selected]['allow']) {
        // configuration has choosen to only allow specifc operators
        var operators = conditions[selected]['allow'];
      } else {
        // use the default operators for this stype
        var operators = attributeOperators[selectedType];
      }

      var options = $.map(operators, function(operator){
        return '<option value="' + operator + '">' + operatorNames[operator] + '</option>'
      });

      // add a blank option so the a change is required to update the UI
      // if there is more than one operator. If the user has chosen to only
      // allow one operator, there is no point in changing the operator
      if(operators.length == 1) {
        fieldset.find('select.condition_operator').html(options.join(' '));
      } else {
        fieldset.find('select.condition_operator').html('<option></option>' + options.join(' '));
      }

      fieldset.find('select.condition_operator').parent().show();

      // set the choices select to the related choices
      if(conditions[selected]['choices'] || conditions[selected]['type'] == 'boolean'){
        // now replace the choices and value html with a fresh set for the operators to manipulate
        fieldset.find('li.choices').replaceWith(fieldset.data('choices-template').clone());

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

        fieldset.find('select.choices').html(choices.join(' '));
        fieldset.find('li.choices').show();

        //fire the change event so the value is set correctly
        fieldset.find('li.choices select').change();
      } else {
        fieldset.find('li.value').replaceWith(fieldset.data('value-template').clone());
      }

      // finally set the type
      fieldset.find('input.type').val(conditions[selected].type);
    });

    $('select.condition_operator', form).live('change', function(ev){
      ev.preventDefault();

      var fieldset = $(this).closest('fieldset');

      var selectedOperator = $(this).val();

      if(selectedOperator == null || selectedOperator == '') return;

      var selectedAttributeKey = fieldset.find('select.condition_attribute').val();

      var selectedAttribute = conditions[selectedAttributeKey];

      if(selectedAttribute.hasOwnProperty('choices') || selectedAttribute.type == 'boolean'){
        // show the select. No transforms allowed.
        fieldset.find('li.choices').show();
        fieldset.find('li.value').hide();

        //fire the change event so the value is set correctly
        fieldset.find('li.choices select').change();

        // only show section if the operator needs a value
        if(selectedOperator == 'blank' || selectedOperator == 'not_blank') {
          fieldset.find('li.value, li.choices').hide();
        }
      } else {
        // ensure a clean slate for the transformations to manipulate
        fieldset.find('li.value').replaceWith(fieldset.data('value-template').clone());

        // choices should be hidden if the value is not from a predefined set
        fieldset.find('li.choices').hide();

        // only show section if the operator needs a value
        if(selectedOperator == 'blank' || selectedOperator == 'not_blank') {
          fieldset.find('li.value, li.choices').hide();
        } else {
          fieldset.find('li.value').show();

          // set and show the hint if it was given
          // else hide it
          if(selectedAttribute.hint != null) {
            fieldset.find('li.value .inline-hints').text(selectedAttribute.hint).show();
          } else {
            fieldset.find('li.value .inline-hints').hide();
          }

          // now run the transform function for the particular type
          if(config.transforms[selectedAttribute['type']]) {
            // build a list of arguments for the transformation function
            var input = $(this).closest('fieldset').find('li.value input')[0];
            config.transforms[selectedAttribute['type']](input, selectedAttribute, selectedOperator);
          } 
        }
      }
    });

    // selecting one from the generated select updateds
    // the value on the associated value
    $('select.choices', form).live('change', function(ev){
      ev.preventDefault();

      var fieldset = $(this).closest('fieldset');

      $('li.value input', fieldset).val($(this).val());
    });

    // handle preloaded conditions
    $('.condition select.condition_attribute.preselected', form).each(function(){
      // ensure the value is set the one choosen previously
      $(this).val($(this).data('selected'));

      // fire the change event to update the ui
      $(this).change();

      // now finally ensure the operator is at the original value
      var fieldset = $(this).closest('fieldset');
      fieldset.find('select.condition_operator').val(fieldset.find('select.condition_operator').data('selected'));

      // fire a change on the operator to set the proper stuff
      fieldset.find('select.condition_operator').change();
    });
  };
})(jQuery); 
