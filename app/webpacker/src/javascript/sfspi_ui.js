function setEnterKeyFor( element, button ) {
  element.keyup(function( event ) {
    if ( event.keyCode === 13 ) {
      button.click();
    }
  });
}

function getDateFromPicker( pickerArray ) {
  return encodeURIComponent(pickerArray.sort(function( a, b ) {
    return a.id.localeCompare(b.id)
  }).map(function() {
    return parseInt($(this).children('option:selected').val())
  }).get().join('-'))
}

function setDivContentFromEventsList( description, contentDiv, data, translator ) {
  contentDiv.html('')
  if(data.length > 0) {
    contentDiv.append(
      $('<p>').append(description)
    )

    var eventList = $('<ul>')
    data.forEach(function(item) {
      eventList.append(
        $('<a>')
        .attr('href', item.href)
        .append(
          $('<li>')
          .append(translator(item))
        )
      )
    })

    contentDiv.append(eventList)
  } else {
    contentDiv.html($('<p>').append("No items for this date."))
  }
}

function setDivToError(contentDiv, error) {
  contentDiv.html($('<p>').append(`Error getting items from server! ${error}`))
}

function requestJsonUpdateDiv(path, description, contentDiv, button, translator) {
  $.getJSON(path)
  .done(function(data) { 
    setDivContentFromEventsList(description, contentDiv, data, translator) 
    if (button) {
      button.prop('disabled', false).attr('value', 'Search');
    }
  })
  .fail(function(jqXHR, textStatus, errorThrown) {
    setDivToError(contentDiv, errorThrown)
  })
}

function setupYearSelector (
  button,
  yearInput,
  searchButton,
  contentDiv,
  descriptionDiv,
  searchPathFunction,
  translator
) {
  $(document).ready(function() {
    setEnterKeyFor(yearInput, button)
    button.click(function() {
      button.prop('disabled', true).attr('value', 'Working...')
      var year = yearInput.val();
      var description = descriptionDiv.html();

      var path = searchPathFunction(year)

      requestJsonUpdateDiv(path, description, contentDiv, button, translator)
    });
    button.trigger('click');
  });
}


const SfspiUi = {
  setupDatePickerAutoSearch: function() {
    $(document).ready(function() {
      $('[id^=event_date_]').change(function() {
        var description = $('div#same_day_events_description').html();
        var date = getDateFromPicker($('[id^=event_date_]'))
        var pdate = Date.parse(date)
        var contentDiv = $('#same_day_events')

        if(!isNaN(pdate) && new Date(date).getFullYear() > 2000) {
          var path = Routes.events_by_date_path(date)
          requestJsonUpdateDiv(path, description, contentDiv, null, function(item) {
            return `${item.name} at ${item.venue}`
          })
        }
      })
    })
  },
  
  setupYearSearchForm: function(searchPathFunction, translator) {
    setupYearSelector(
      $('#search_button'),
      $('#select_year'),
      $('#search_button'),
      $('#search_results'),
      $('#search_description'),
      searchPathFunction,
      translator
    );
  },

  meetingsTranslator: function(item) {
    return `${item.type} on ${item.date}`
  }
};

export default SfspiUi
