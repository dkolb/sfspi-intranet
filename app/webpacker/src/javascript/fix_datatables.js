const fixDataTables = function(tableId) {
  //Add padding and d-flex to row container
  $(`${tableId}_wrapper div:first`).addClass('py-3 d-flex')

  // Fix select. 
  var select = $(`${tableId}_length`).children().children()
  select.removeClass('form-control-sm').removeClass('custom-select-sm')
  $(`${tableId}_length`).html(
    $('<div>').addClass('input-group').append(
      $('<div>').addClass('input-group-prepend').append(
        $('<div>').addClass('input-group-text').html('Show')
      ),
      select,
      $('<div>').addClass('input-group-append').append(
        $('<div>').addClass('input-group-text').html('entries')
      )
    )
  )

  $(`${tableId}_length`).parent().addClass('mr-auto').removeClass('col-sm-12').removeClass('col-md-6')

  //Fix search.
  var search = $(`${tableId}_filter`).children().children()
  search.removeClass('form-control-sm')
  $(`${tableId}_filter`).html(
    $('<div>').addClass('input-group').append(
      $('<div>').addClass('input-group-prepend').append(
        $('<div>').addClass('input-group-text').html('Search:')
      ),
      search
    )
  )
  $(`${tableId}_filter`).parent().removeClass('col-sm-12').removeClass('col-md-6')
}

export default fixDataTables
