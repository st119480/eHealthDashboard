jQuery ->
  districts = $('#user_district_id').html()
  $('#user_province_id').change ->
    province = $('#user_province_id :selected').text()
    options = $(districts).filter("optgroup[label='#{province}']").html()
    if options
      $('#user_district_id').html(options)
    else
      $('#user_district_id').empty()