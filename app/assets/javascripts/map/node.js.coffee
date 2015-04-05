###########################
# Class corresponding to a Marker on the map
# TODO : Rename Node -> Marker, node_obj -> marker
# @node: node model from the server. If @node.real is true, @node correspond s
# truly to a model in the db, else, it's a fake node.
# @marker: marker on the map, class from Leaflet
# @characters: characters models fetch by ids in @node.character_ids
# @character_names: Property calculated from @characters
###########################
class Map.Node
  # Create a marker on the map
  constructor: (node) ->
    @node = @clone_node(node)
    @targeted = false
    @update_characters()
    @marker = L.marker([@node.latitude, @node.longitude], 
      {"draggable": true, "title": @character_names})
      
    # Add the node in NodeCollection and @marker on Map
    @on_map = false
    if !Map.node_collection.fetch(@node.id)
      Map.node_collection.register(this)
      Map.map.addLayer(@marker)
      @on_map = true
    else
      console.log "#{@node.id} already present (same node for multiple characters)"
      
    @popup = false
    @resize_marker()
    @update_popup()
    
    @marker.on('drag', (e) =>
      closest = Map.node_collection.closest(this)
      @deselect_target()
      if closest
        @select_target(closest)
    )
    @marker.on('dragend', (e) =>
      @restore_point()
      if @target
        # Fuuuuusion !
        console.log('Fuuuuusion')     
        concerned_ch_id = null
        if @node.character_ids.length >= 1 # TODOOO BUG
          concerned_ch_id = @node.character_ids[0]
        else
          alert("NO CHARACTER IN THIS FUCKING NODE ? HOW IS THAT POSSIBLE ? Contact juleffel@hotmail.fr.")
          # TODOOO BUG
          concerned_ch_id = null #main_character.id
        
        # Join points and create a node
        if @target.node.real
          # Update it
          if @node.real
            # Target and source are real
            # TODO : two solutions : transfer all or just the main character
            # Remove character from the source
            @remove_character(concerned_ch_id)
            # Update target adding a character
            @target.add_character(concerned_ch_id)
          else
            # Only target is real
            # Update it adding a character
            @target.add_character(concerned_ch_id)
        else
          target_ch_id = @target.node.character_ids[0]
          if @node.real
            # Only source is real
            # Deplace source and update it adding a character
            @node.latitude = @target.node.latitude
            @node.longitude = @target.node.longitude
            @add_character(target_ch_id)
          else
            # Nodes aren't real
            # Create a new node
            @node.latitude = @target.node.latitude
            @node.longitude = @target.node.longitude
            ok = @set_node_default_values()
            if not ok
              @restore_node()
            else
              @node.character_ids.push(target_ch_id)
              @update_characters()
              @create_on_server()
        @deselect_target()
      else
        console.log("Deplacement")
        latlng = @marker.getLatLng()
        [@node.latitude, @node.longitude] = [latlng.lat, latlng.lng]
        if @node.real
          @update_on_server()
        else
          @create_new_real_node()
    )
    #console.log @node, "created"
  clone_node: (node) ->
    $.extend(true, {}, node)
  restore_point: ->
    @old_node = @node
    @node = @clone_node(@node)
    #console.log "restore point:", @old_node
  restore_node: ->
    console.log "restore node:", @node, "->", @old_node
    if !!@old_node
      @node = @old_node
      @old_node = null
      @update_node(@node)
  
  fill_informations: ->
    title = prompt("Titre")
    if title == null
      return false
    summary = prompt("Résumé")
    if summary == null
      return false
    @node.title = title
    @node.resume = summary
    delete @node.topic_id
    return true
  set_default_dates: ->
    @node.begin_at = Map.character_list.last_date
    delete @node.end_at
  set_node_default_values: ->
    ok = @fill_informations()
    if not ok
      return false
    @set_default_dates()
    return true
  create_new_real_node: () ->
    ok = @set_node_default_values()
    if ok
      @create_on_server()
    else
      @restore_node()
  
  # Updates the position of the marker on the map
  update_latlng: ->
    @marker.setLatLng([@node.latitude, @node.longitude])
  
  # Distance fro another node_obj
  distance_from: (node_obj)->
    @marker.getLatLng().distanceTo(node_obj.marker.getLatLng())
  
  select_target: (node_obj)->
    @target = node_obj
    node_obj.is_targeted() 
  
  deselect_target: ()->
    if @target
      @target.is_untargeted()
    @target = null
    
  is_targeted: ->
    @targeted = true
    @resize_marker()
    
  is_untargeted: ->
    @targeted = false
    @resize_marker()
  
  # Update whole content of node (popup, positionn, size)
  # according to the content of node
  update_node: (node) ->
    #console.log("Update node content", @node.title, "->", node.title)
    if @node.real == node.real && @node.id == node.id
      # The node is real and hasn't change from the last time
      # We just make it move (normally not necessary but... ?)
      @node = node
      @update_latlng()
    else
      # Not the same node as before, update all attributes
      console.log("Changement of node :", @node, "->", node)
      Map.node_collection.remove(this)
      
      @node = @clone_node(node)
      @update_characters()
      
      if fetch = Map.node_collection.fetch(@node.id)
        console.log("fetch ok")
        # Already present on the map (topic)
        if @on_map
          console.log("on_map -> hide yourself, there is someone else", fetch)
          Map.map.removeLayer(@marker)
          @on_map = false
      else
        # Not present, add it
        console.log("fetch fail, register...")
        Map.node_collection.register(this)
        if !@on_map
          console.log("not on_map -> show yourself, there is noone else")
          Map.map.addLayer(@marker)
          @on_map = true
      @update_marker()
      
  # Return the content of the popup of the marker.
  # Must be null to not create a popup
  popup_content: ->
    if @node.real
      str = ""
      str += "<h4>#{@node.title}</h4>" if !window.blank(@node.title)
      str += "<p>#{@node.resume}</p>" if !window.blank(@node.resume)
      str += "<small>#{@character_names}</small>" if !window.blank(@character_names)
    else
      null
    
  # Change the icon of the marker according the importance of the node
  resize_marker: ->
    @update_dragging()
    if @owned
      @marker.setZIndexOffset(100)
    else
      @marker.setZIndexOffset(0)
    size = 'small'
    if @targeted
      # Fusion will come
      size = 'large'
    else if @node.real && @node.title && @node.title.length > 0
      # Real node with a title
      if @node.topic_id
        # This node include a topic
        size = 'large'
      else
        # This node is just an information of deplacement
        size = 'medium'
    else
      # Not real node (character is in a traject) or Node has'nt a title
      size = 'small'
    
    n = @characters.length
    sizes = {
      'small': 36 * (1+(n-1)*0.15),
      'medium': 50 * (1+(n-1)*0.15),
      'large': 60 * (1+(n-1)*0.15),
    }
    s = sizes[size]
    html = @icon_html_4_characters()
    icon = L.divIcon({iconSize: [s, s], popupAnchor: [0, -s/3], className: 'map-character-icon', html: html})
    @marker.setIcon(icon)
  update_dragging: ->
    if @marker and @marker.dragging and @on_map
      if @owned
        @marker.dragging.enable();
      else
        @marker.dragging.disable();
    
  img_html_4_character: (character) ->
    if character.small_image_url and character.small_image_url != ""
      url = character.small_image_url
    else
      url = 'http://upledger.com/btd15/img/presenters/missing_avatar.png'
  icon_html_4_characters: ->
    l = @characters.length
    if @owned
      gear = 'http://img15.hostingpics.net/pics/663529gearwheel2small.png'
    else
      gear = 'http://img15.hostingpics.net/pics/369641gearwheel1small.png'
    gear_html = "<img class='gear' src='#{gear}'/>"
    if l == 0
      html = "<div class='frame frame-0'>"+gear_html
      alert("BIG BUG, MOMMY!")
      console.log("@characters shouldn't be empty")
    else if l == 1
      html = "<div class='frame frame-1'>"+gear_html
      html += "<div class='avatar avatar-1 avatars-1'><img src='#{@img_html_4_character(@characters[0])}'/></div>"
    else if l == 2
      html = "<div class='frame frame-2'>"+gear_html
      html += "<div class='avatar avatar-1 avatars-2'><img src='#{@img_html_4_character(@characters[0])}'/></div>"
      html += "<div class='avatar avatar-2 avatars-2'><img src='#{@img_html_4_character(@characters[1])}'/></div>"
    else
      html = "<div class='frame frame-3more frame-#{l}'>"+gear_html
      for character, ind in @characters
        size_perc = 0.6 # %
        rad = Math.PI/2-ind/l*2*Math.PI
        x = (( 0.5 + 0.5*Math.cos(rad) * 0.8 ) - size_perc/2) * 100 # %
        y = (( 0.5 + 0.5*Math.sin(rad) * 0.8 ) - size_perc/2) * 100 # %
        style = "left: #{x}%; bottom: #{y}%;"
        html += "<div class='avatar avatars-3more avatar-#{ind} avatars-#{l}' style='#{style}'>"
        html += "<img src='#{@img_html_4_character(character)}'/>"
        html += "</div>"
    html += "</div>"
    html
  
  # Remove the marker from the map
  destroy_popup: ->
    @marker.closePopup()
    @marker.unbindPopup()
    @popup = false
  # Update the popup of the node, remove it if necessary
  update_popup: ->
    cont = @popup_content()
    if cont?
      if @popup
        # Only update content
        @marker.setPopupContent cont
      else
        # Create a new popup
        @marker.bindPopup cont, {autoPan: false, autoClose: false}
        @marker.openPopup()
        @popup = true
    else
      # Not real node
      @destroy_popup()
  update_marker: ->
    @resize_marker()
    @update_popup()
    @update_latlng()
    
  # Destroy popup and marker
  destroy: ->
    @destroy_popup()
    if fetch = Map.node_collection.fetch(@node.id)
      Map.node_collection.remove(this)
      if fetch != this
        fetch.destroy()
    if @on_map
      Map.map.removeLayer(@marker)
      @on_map = false
      
  # Idem + on server
  really_destroy: ->
    @restore_point()
    @delete_on_server()
    @destroy()
    
  # Fetch characters model by @node.character_ids
  # Calculate @character_names
  update_characters: ->
    @characters = []
    @owned = false
    for ch_id in @node.character_ids
      ch = Map.character_list.characters_by_id[ch_id]
      @owned ||= ch.owned
      @characters.push(ch)
    @character_names = ""
    for character in @characters
      @character_names += character.name + ' '
      
  # add a character to the node (serverside too)
  add_character: (id)->
    @restore_point()
    @node.character_ids.push(id)
    @update_characters()
    @update_on_server()
    
  # remove a character from the node
  # if the node has only one character, it is removed
  remove_character: (id)->
    @restore_point()
    if @node.character_ids.length <= 1
      @really_destroy()
    else
      # Remove character id from @node.character_ids
      ind = 0
      while (ind = @node.character_ids.indexOf(id)) != -1
        @node.character_ids.splice(ind, 1)
      @update_characters()
      @update_on_server()
  
  node2spacetime_position: (node) ->
    spacetime_position = $.extend({}, node)
    delete spacetime_position.created_at
    delete spacetime_position.updated_at
    delete spacetime_position.user_id
    delete spacetime_position.birth
    delete spacetime_position.real
    spacetime_position
  # Update @node on server
  update_on_server: () ->
    if @node.id and @node.id > 0
      @update_marker()
      $.ajax
        type: "PUT"
        url: "/spacetime_positions/"+@node.id
        data: 
          spacetime_position: @node2spacetime_position(@node)
        dataType: "json"
        success: =>
          console.log "Node #{@node.id} updated on server."
          @old_node = null
        error: =>
          alert "Error on server ! Node #{@node.id} can't be updated."
          @restore_node()
    else
      alert("update a non real node !")
      @restore_node()
  # Create @node on server
  create_on_server: (old_latlng) ->
    #alert('create on server !')
    @update_marker()
    $.ajax
      type: "POST"
      url: "/spacetime_positions/"
      data: 
        spacetime_position: @node2spacetime_position(@node)
      dataType: "json"
      success: (new_node) =>
        console.log "Node created on server. Res :", new_node
        # Let this marker live it's life, it will be removed by the refetch from server
        if @marker and @marker.dragging
          @marker.dragging.disable()
        @old_node = null
      error: =>
        alert "Error on server ! Node can't be created."
        @restore_node()
  # Update @node on server
  delete_on_server: ->
    alert("delete a non real node !") unless @node.id != 0
    $.ajax
      type: "DELETE"
      url: "/spacetime_positions/"+@node.id
      dataType: "json"
      success: =>
        console.log "Node #{@node.id} deleted on server."
        @old_node = null
      error: =>
        alert "Error on server ! Node #{@node.id} can't be deleted."
        @restore_node()