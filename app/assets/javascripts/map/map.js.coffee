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
    L.tileLayer('http://a.tiles.mapbox.com/v3/examples.xqwfusor/{z}/{x}/{y}.png', {
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
    from = window.j_date(window.json_data($date_slider, "from"))
    from_date = from.valueOf()
    to = window.j_date(window.json_data($date_slider, "to"))
    hour_in_ms = 1000*60*60
    day_in_ms = hour_in_ms*24
    
    # Modif the sample to precise the time
    sample = hour_in_ms
    
    duration = (to-from)/sample
    
    # integer -> date
    integer2date = (value)->
      new Date(from_date+value*sample)
      
    # Send the date to the character_list
    update_date = (date)->
      Map.character_list.update_date(date)
    # Begin to the current date (the last)
    update_date(to)
    # Set the slider correctly
    $date_slider.bootstrapSlider({
      formatter: (value) -> (
        integer2date(value).toLocaleString()
      ),
      step: 1,
      min: 0,
      max: duration,
      value: duration,
    }).on('slide', (slide) -> 
      update_date(integer2date(slide.value))
    )
    
