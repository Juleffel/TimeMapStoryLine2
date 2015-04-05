###############################
# Class for stock and update automitically the character list and their nodes
# @characters: models from the db
# @list: list of Character objects
# @updated_at: store the value of @characters_updated_at at each fetch from the db
# @last_date: store the value of the date of the slider
###############################
class Map.CharacterList
  constructor: ->
    @characters_by_id = {}
    @construct_list()
    @updated_at = null
    # Refresh data by AJAX every 3 seconds # TODO Adjust
    @verify_updates_on_server()
    @interval = setInterval( =>
      @verify_updates_on_server()
    1000)
  stop: ->
    clearInterval(@interval)
  
  destroy_list: ->
    if @list
      for character in @list
        character.destroy()
    @list = []
  
  # Destroy and recreate the list of the characters objects
  construct_list: ->
    @destroy_list()
    for id, character of @characters_by_id
      @list.push(new Map.Character(character))
    last_date = @last_date         
    if last_date
      @last_date = null
      @update_date(last_date)
  
  verify_updates_on_server: ->
    $.ajax
      type: "GET"
      url: "/characters/map"
      dataType: "json"
      success: (data) =>
        if data.characters_updated_at != @updated_at
          console.log "Something has changed on server... Launch update."
          @updated_at = data.characters_updated_at
          @update_from_server()
  
  # Fetch characters and spacetime_positions(nodes) from server
  update_from_server: ->
    $.ajax
      type: "GET"
      url: "/characters/map"
      dataType: "json"
      data:
        all: true
      success: (data) =>
        @updated_at = data.characters_updated_at
        @characters_by_id = data.characters_by_id
        # Parse dates
        for id, ch of @characters_by_id
          @characters_by_id[id].updated_at = window.j_date(ch.updated_at)
          @characters_by_id[id].created_at = window.j_date(ch.created_at)
          @characters_by_id[id].map_nodes_updated_at = window.j_date(ch.map_nodes_updated_at)
          @characters_by_id[id].owned = Map.current_user_id and @characters_by_id[id].user_id == Map.current_user_id
        nodes_by_id = data.spacetime_positions_by_id
        # Parse dates
        for id, node of nodes_by_id
          nodes_by_id[id].updated_at = window.j_date(node.updated_at)
          nodes_by_id[id].created_at = window.j_date(node.created_at)
          nodes_by_id[id].begin_at = window.j_date(node.begin_at)
          nodes_by_id[id].end_at = window.j_date(node.end_at)
        Map.nodes_by_id = nodes_by_id
        Map.topics_by_id = data.topics_by_id
        @update()
  # Update only the characters that have been changed since the last fetch
  update: ->
    # Something has changed since last loading
    if Object.size(@characters_by_id) == @list.length
      ind = 0
      for id, new_ch of @characters_by_id
        old_ch = @list[ind].character
        if old_ch.id != new_ch.id
          # Not the same character at the same position as before (id are always sorted ASC by the "for .. of")
          console.log "Not the same character at the same position as before. Reload all map."
          console.log(@characters_by_id, @list)
          @construct_list()
          break
        if old_ch.updated_at - new_ch.updated_at != 0
          # Character (or its nodes) updated
          console.log "Character", new_ch.name, "has been updated on server. Reload this character and its nodes."
          #console.log "ch", new_ch, "updated"
          @list[ind].update_character(new_ch)
        else if old_ch.map_nodes_updated_at - new_ch.map_nodes_updated_at != 0
          # Character_nodes updated
          console.log "Some nodes of character", new_ch.name, "have been updated on server. Reload its nodes."
          @list[ind].update_character_nodes(new_ch)
        ind++
    else
      # not the same number of characters as before
      console.log "Not the same number of characters as before"
      @construct_list()
  # Updates the date for all the characters of the map
  update_date: (new_date, force = false)->
    #console.log "-> nd #{new_date} (@ #{@last_date}) (#{force})"
    if force or !@last_date or (new_date - @last_date != 0)
      #console.log(!@last_date, (new_date - @last_date))
      #console.log "-> @"
      @last_date = new_date
      if !@date_blocked
        # One modif max for 15 ms
        console.log "<- @ #{new_date} [["
        @date_blocked = true
        setTimeout( =>
          @date_blocked = false
          #console.log "]["
          # Ensure that the last date set is the one on the slider
          setTimeout( =>
            #console.log "tt nd #{new_date} (@ #{@last_date}) (#{@date_blocked})"
            if !@date_blocked && (@last_date - new_date != 0)
              #console.log "-> @ #{@last_date}"
              @update_date(@last_date, true)
          10)
        15)
        for c in @list
          c.update_date(new_date)
      else
        null
        #console.log "]]"