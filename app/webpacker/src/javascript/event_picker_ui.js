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

function setDivContentFromEventsList( description, contentDiv, data ) {
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
          .append(`${item.name} at ${item.venue}`)
        )
      )
    })

    contentDiv.append(eventList)
  } else {
    contentDiv.html($('<p>').append("No events on this date."))
  }
}

function setDivToError(contentDiv, error) {
  contentDiv.html($('<p>').append(`Error getting events! ${error}`))
}

function requestJsonUpdateDiv(path, description, contentDiv) {
  $.getJSON(path)
  .done(function(data) { 
    setDivContentFromEventsList(description, contentDiv, data) 
  })
  .fail(function(jqXHR, textStatus, errorThrown) {
    setDivToError(contentDiv, errorThrown)
  })
}


const EventPickerUi = {
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
  
  setupSelectEventDateSearch: function() {
    $(document).ready(function() {
      var button = $('#search_button')
      setEnterKeyFor($('#select_month'), button)
      setEnterKeyFor($('#select_year'), button)
      button.click(function() {
        button.prop('disabled', true).html('Working...')
        var month = $('#select_month').val();
        var year = $('#select_year').val();
        var description = $('div#event_search_description').html();

        var start = moment(year + '-' + month, 'YYYY-MM');
        var path = Routes.events_by_date_range_path(
          start.format('YYYY-MM-DD'),
          start.add(1, 'months').format('YYYY-MM-DD')
        )

        var contentDiv = $('#event_search_results')

        requestJsonUpdateDiv(path, description, contentDiv)

        button.prop('disabled', false).html('Search');
      });
    });
  },

};

export default EventPickerUi
