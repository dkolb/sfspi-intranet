function setEnterKeyFor(buttonId) {
  $('#' + buttonId).keyup(function(event) {
    if (event.keyCode === 13) {
      $('#search_button').click();
    }
  });
}

const EventPickerUi = {
  setupDatePickerAutoSearch: function() {
    $(document).ready(function() {
      $('#event_date').change(function() {
        var description = $('div#same_day_events_description').html();
        var date = encodeURIComponent($('#event_date').val());
        var pdate = Date.parse(date);

        if(!isNaN(pdate) && new Date(date).getFullYear() > 2000) {
          $.getJSON(Routes.events_by_date_path(date), function(data, error) {
            if(data.length > 0) {
              var content = [
                "<p>" + description + "</p>"
              ];
              content.push('<ul>');
              $.each(data, function(index, item) {
                content.push('<a href="' + item.id + '">');
                content.push('<li>' + item.name + ' at ' + item.venue + '</li>');
                content.push('</a>');
              })
              $('#same_day_events').html(content.join(""));
            } else {
              $('#same_day_events').html("No events on this date.")
            }
          });
        }
      });
    })
  },
  
  setupSelectEventDateSearch: function() {
    $(document).ready(function() {
      setEnterKeyFor('select_month');
      setEnterKeyFor('select_year');
      $('#search_button').click(function() {
        $('#search_button').prop('disabled', true).html('Working...')
        var month = $('#select_month').val();
        var year = $('#select_year').val();
        var description = $('div#same_day_events_description').html();

        var start = moment(year + '-' + month, 'YYYY-MM');
        var path = Routes.events_by_date_range_path(
          start.format('YYYY-MM-DD'),
          start.add(1, 'months').format('YYYY-MM-DD')
        )

        $.getJSON(path, function(data, err) {
          if(data.length > 0) {
            var content = [
              "<p>" + description + "</p>"
            ];
            content.push('<ul>');
            $.each(data, function(index, item) {
              content.push('<a href="' + item.id + '">');
              content.push('<li>');
              content.push(item.date + ': ' + item.name + ' at ' + item.venue);
              content.push('</li>');
              content.push('</a>');
            })
            $('#same_day_events').html(content.join(""));
          } else {
            $('#same_day_events').html("No events on this date.");
          }

          $('#search_button').prop('disabled', false).html('Search');
        });
      });
    });
  },

  safariDatePicker: function() {
    $(document).ready(function() {
      $('.datepicker').datepicker( { dateFormat: "yy-mm-dd" } );
    });
  }

};

export default EventPickerUi
