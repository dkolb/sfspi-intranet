function setupDatePickerAutoSearch() {
  $(document).ready(function() {
    $('#event_date').change(function() {
      description = $('div#same_day_events_description').html();
      var date = encodeURIComponent($('#event_date').val());
      var pdate = Date.parse(date);

      if(isNaN(pdate) || new Date(date).getFullYear() < 2000) {
      } else {
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
}

function setupSelectEventDateSearch() {
  $(document).ready(function() {
    $('#search_button').click(function() {
      $('#search_button').prop('disabled', true).html('Working...')
      month = $('#event_month').val();
      year = $('#event_year').val();
      description = $('div#same_day_events_description').html();

      start = moment(year + '-' + month);
      path = Routes.events_by_date_range_path(
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
}
