# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ = jQuery



$ ->

  $map = $("#map")

  if $map.length
    #southWest = new L.LatLng(-260, -180)
    #northEast = new L.LatLng(340, 560)
    #bounds = new L.LatLngBounds(southWest, northEast)

    ###map = L.map('map', {
      maxBounds: bounds,
    }).setView([20, 50], 2)###

    Map.map = L.map('map', {
      #maxBounds: bounds,
    }).setView([33.45772,-89.802246], 6)

    #cloudmade_api_key = $map.data("cloudmade-api-key")
    L.Icon.Default.imagePath = "http://leafletjs.com/dist/images"

    ###L.tileLayer("http://fortests.chez.com/carte_arven/{z}/{x}/{y}.png", {
        attribution: '&copy; <a href="http://dragonvale.forumactif.org">Dragonvale</a>',
        maxZoom: 4,
        tms: true,
        continuousWorld: true,
        noWrap: true
    }).addTo(Map.map)###
    ###L.tileLayer("http://{s}.tile.cloudmade.com/#{cloudmade_api_key}/997/256/{z}/{x}/{y}.png", {
        attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
        maxZoom: 18
    }).addTo(Map.map)###
    ###window.mapbox_api = 'https://www.mapbox.com/core'
    window.mapbox_tileApi = 'https://api.tiles.mapbox.com'
    window.mapbox_accessToken = 'pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpbG10dnA3NzY3OTZ0dmtwejN2ZnUycjYifQ.1W5oTOnWXQ9R1w8u3Oo1yA' || 'pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpbG10dnA3NzY3OTZ0dmtwejN2ZnUycjYifQ.1W5oTOnWXQ9R1w8u3Oo1yA'
    if (typeof L !== 'undefined' && L.mapbox.VERSION[0] === '2')
        L.mapbox.accessToken = window.mapbox_accessToken
        L.mapbox.config.FORCE_HTTPS = true
        L.mapbox.config.HTTPS_URL = window.mapbox_tileApi + '/v4'###
    L.tileLayer('https://a.tiles.mapbox.com/v4/mapbox.b0v97egc/{z}/{x}/{y}.png?access_token=pk.eyJ1IjoibWFwYm94IiwiYSI6ImNpbG10dnA3NzY3OTZ0dmtwejN2ZnUycjYifQ.1W5oTOnWXQ9R1w8u3Oo1yA', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(Map.map);

    # TODO : choose your character
    #main_character = characters[0]
    #Map.user_character_ids = $map.data("user-character-ids")
    Map.current_user_id = $map.data("current-user-id")
    Map.node_collection = new Map.NodeCollection
    Map.character_list = new Map.CharacterList

    ###############
    # Date Slider #
    ###############
    $date_slider = $("#date-slider")
    #from = window.j_date(window.json_data($date_slider, "from"))
    #from_date = from.valueOf()
    date_to_orig = window.j_date(window.json_data($date_slider, "to"))
    date_to = date_to_orig
    date_by = parseInt(window.json_data($date_slider, "by"))
    hour_in_ms = 1000*60*60
    day_in_ms = hour_in_ms*24
    minusBy = (date) ->
      new Date(date.valueOf() - date_by*day_in_ms)
    plusBy = (date) ->
      new Date(date.valueOf() + date_by*day_in_ms)
    date_from = minusBy(date_to)
    #console.log(date_from,date_by,date_to)

    date_url = window.url('?date')
    date_now = null
    if date_url != ""
      date_now = window.j_date(date_url)
    if not date_now or not date_now.valueOf()
      date_now = date_to
    else
      while date_now > date_to
        date_from = date_to
        date_to = plusBy(date_from)
      while date_now < date_from
        date_to = date_from
        date_from = minusBy(date_to)

    # Modif the sample to precise the time
    sample = hour_in_ms

    #console.log((date_now-date_from)/sample)
    #console.log((date_to-date_from)/sample)
    duration = (date_to-date_from)/sample

    # integer -> date
    integer2date = (value)->
      #console.log(date_from, value, sample)
      new Date(date_from.valueOf()+value*sample)

    #console.log(integer2date((date_now-date_from)/sample))
    #console.log(date_from)
    #console.log(date_from.toLocaleString())

    #Control appearance of "Next week" button
    refresh_next_week = () ->
      if date_to >= date_to_orig
        $('.js-map-next-week').hide()
        $('.js-map-today').show()
      else
        $('.js-map-next-week').show()
        $('.js-map-today').hide()

    # Send the date to the character_list
    update_date = (date)->
      Map.character_list.update_date(date)

    $('.js-map-prev-week').click(->
      date_to = date_from
      date_from = minusBy(date_to)
      #console.log(date_to,date_from)
      refresh_next_week()
      update_date(date_to)
      $date_slider.bootstrapSlider('setValue', duration)
    )
    $('.js-map-next-week').click(->
      date_from = date_to
      date_to = plusBy(date_from)
      #console.log(date_to,date_from)
      refresh_next_week()
      update_date(date_from)
      $date_slider.bootstrapSlider('setValue', 0)
    )
    $('.js-map-today').click(->
      date_to = date_to_orig
      date_from = minusBy(date_to)
      #console.log(date_to,date_from)
      refresh_next_week()
      update_date(date_to)
      $date_slider.bootstrapSlider('setValue', duration)
    )

    # Begin to the current date (the last)
    update_date(date_now)
    refresh_next_week()

    # Set the slider correctly
    $date_slider.bootstrapSlider({
      formatter: (value) -> (
        integer2date(value).format("french")
      ),
      tooltip: 'always',
      step: 1,
      min: 0,
      max: duration,
      value: (date_now-date_from)/sample,
    }).on('change', (slide) ->
      update_date(integer2date(slide.value.newValue))
    )
