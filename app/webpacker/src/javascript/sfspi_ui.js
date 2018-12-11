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
    contentDiv.html($('<p>').append("No events on this date."))
  }
}

function setDivToError(contentDiv, error) {
  contentDiv.html($('<p>').append(`Error getting items from server! ${error}`))
}

function requestJsonUpdateDiv(path, description, contentDiv, button, translator) {
  $.getJSON(path)
  .done(function(data) { 
    setDivContentFromEventsList(description, contentDiv, data, translator) 
    button.prop('disabled', false).attr('value', 'Search');
  })
  .fail(function(jqXHR, textStatus, errorThrown) {
    setDivToError(contentDiv, errorThrown)
  })
}

function setupDateSelector (
  button,
  monthInput,
  yearInput,
  searchButton,
  contentDiv,
  descriptionDiv,
  searchPathFunction,
  translator
) {
  $(document).ready(function() {
    setEnterKeyFor(monthInput, button)
    setEnterKeyFor(yearInput, button)
    button.click(function() {
      button.prop('disabled', true).attr('value', 'Working...')
      var month = monthInput.val();
      var year = yearInput.val();
      var description = descriptionDiv.html();

      var start = moment(year + '-' + month, 'YYYY-MM');
      var path = searchPathFunction(
        start.format('YYYY-MM-DD'),
        start.add(1, 'months').format('YYYY-MM-DD')
      )

      requestJsonUpdateDiv(path, description, contentDiv, button, translator)
    });
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
          requestJsonUpdateDiv(path, description, contentDiv)
        }
      })
    })
  },
  
  setupDateSearchForm: function(searchPathFunction, translator) {
    setupDateSelector(
      $('#search_button'),
      $('#select_month'),
      $('#select_year'),
      $('#search_button'),
      $('#search_results'),
      $('#search_description'),
      searchPathFunction,
      translator
    );
  },

  eventsTranslator: function(item) {
    return `${item.name} at ${item.venue} on ${item.date}`
  },

  meetingsTranslator: function(item) {
    return `${item.type} on ${item.date}`
  }
};

export default SfspiUi
