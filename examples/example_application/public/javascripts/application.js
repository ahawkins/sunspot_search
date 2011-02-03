
$(function(){
  $('#basic-search form').sunspotSearch();

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
  
  var numericTransform = function(input, condition, operator) {
    // only want to make one condition a slider
    var sliderContainer  = $('<div class="sliderContainer"/>');
    var sliderLabel = $('<label/>');
    var slider = $('<div class="slider" />');

    sliderContainer.prepend(sliderLabel).append(slider);
    $(input).parent().addClass('slider');
    $(input).after(sliderContainer).hide();
    $(slider).slider({
      max: condition.extras.max, 
      min: condition.extras.min, 
      step: condition.extras.step,
      range: operator == 'between',
      slide: function(event, ui) {
        if(operator == 'between') {
          $(sliderContainer).find('label').text(ui.values[0] + ' - ' + ui.values[1]);
          $(input).val(ui.values[0] + ' - ' + ui.values[1]);
        } else {
          $(sliderContainer).find('label').text(ui.value);
          $(input).val(ui.value);
        }
      }
    });

    $(input).hide();
    $(input).closest('li').children('label:first-child').text(' ');
  }

  $('#advanced-search form').sunspotSearch({
    'date': dateTimeTransform,
    'time': dateTimeTransform,
    'currency': numericTransform,
    'integer': numericTransform,
    'float': numericTransform
  });
});
