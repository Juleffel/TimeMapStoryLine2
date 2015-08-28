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
      console.log "Node creation <#{@node.id}>: NOT found in node_collection, register and display on map" 
      Map.node_collection.register(this)
      Map.map.addLayer(@marker)
      console.log "<#{@character_names}> [ON MAP]"
      @on_map = true
    else
      console.log "Node creation <#{@node.id}>: found in node_collection. Do nothing"
      Map.node_collection.update(this)
      
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
        @target.restore_point()
        concerned_ch_id = null
        deselect = true
        if @node.character_ids.length < 1 # TODOOO BUG
          alert("NO CHARACTER IN THIS FUCKING NODE ? HOW IS THAT POSSIBLE ? Contact juleffel@hotmail.fr.")
          @restore_node()
        else
          # Join points and create a node
          if @node.real and (!window.blank(@node.title) or !window.blank(@node.resume) or  @node.character_ids.length > 1 or @node.topic_id > 0)
            plural = false
            if @target.node.character_ids.length > 1
              plural = true
            str = "Vous ne pouvez pas rejoindre ce"
            if plural
              str += "s"
            str += " personnage"
            if plural
              str += "s"
            str += " car vous avez créé une position ailleurs auparavant, à la même date."
            str += "Merci de quitter ce noeud (croix rouge à côté de votre personnage, dans le popup) avant de procéder à la fusion."
            alert(str)
            @restore_node()
          else
            ch_id = @node.character_ids[0]
            if @node.real
              if @target.node.real
                # Both source and target are real
                # Remove character from the source
                console.log "Both source and target are real"
                _target = @target
                @remove_character(ch_id, ->
                  # If remove ok on server
                  # Update target adding a character
                  _target.add_character(ch_id)
                )
              else
                # Only source is real
                console.log "Only source is real"
                # Deplace source and update it adding a character
                target_ch_id = @target.node.character_ids[0]
                @node.latitude = @target.node.latitude
                @node.longitude = @target.node.longitude
                @add_character(target_ch_id)
            else
              if @target.node.real
                # Only target is real
                console.log "Only target is real"
                # Update it adding a character
                @target.add_character(ch_id)
              else
                # Both source and target aren't real
                console.log "Both source and target aren't real"
                # Create a new node
                @node.latitude = @target.node.latitude
                @node.longitude = @target.node.longitude
                deselect = false
                @set_node_values(this,
                  ((__this) -> # Success
                    target_ch_id = __this.target.node.character_ids[0]
                    __this.node.character_ids.push(target_ch_id)
                    __this.update_characters()
                    __this.create_on_server()
                    __this.deselect_target()
                  ),((__this) -> # Failure
                    __this.deselect_target()
                    __this.restore_node()
                  ),true # Set defaults
                )
        if deselect
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
      
  set_default_dates: ->
    @node.begin_at = Map.character_list.last_date
    delete @node.end_at
  
  set_node_values: (__this, callback_success, callback_failure, defaults) ->
    bootbox.prompt(
      size: 'small',
      title: 'Titre',
      locale: 'fr',
      value: __this.node.title if !defaults,
      placeholder: "Entrez le titre du topic" if defaults,
      message: "Entrez le titre du topic", 
      callback: ((title) ->
        if title != null
          bootbox.prompt(
            size: 'large',
            title: 'Résumé',
            inputType: 'textarea',
            value: __this.node.resume if !defaults,
            placeholder: "Entrez le résumé du topic" if defaults,
            locale: 'fr',
            message: "Entrez le résumé du topic", 
            callback: ((summary) ->
              if summary != null
                __this.node.title = title
                __this.node.resume = summary
                if defaults
                  delete __this.node.topic_id
                  __this.set_default_dates()
                callback_success(__this)
              else
                callback_failure(__this)
            )
          )
        else
          callback_failure(__this)
      )
    )
    
  edit_node: () ->
    @set_node_values(this,
      ((__this) -> # Success
        __this.update_on_server()
      ),((__this) -> # Failure
        __this.restore_node()
      ),false # Set defaults
    )
    
  create_new_real_node: ->
    @set_node_values(this,
      ((__this) -> # Success
        __this.create_on_server()
      ),((__this) -> # Failure
        __this.restore_node()
      ),true # Set defaults
    )
  
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
      console.log "Node update: #{@node.id} <- #{node.id}"
      console.log "Remove old node from node collection"
      Map.node_collection.remove(this)
      
      @node = @clone_node(node)
      @update_characters()
      
      if fetch = Map.node_collection.fetch(@node.id)
        console.log("#{@node.id} found in node_collection")
        Map.node_collection.update(this) #update node in node_collection, in case it is fetch and used while fusion (#brainfuck)
        # Already present on the map (topic)
        if @on_map
          console.log("Previous node was already on map. Hide the marker", fetch, @node, @old_node)
          Map.map.removeLayer(@marker)
          console.log "<#{@character_names}> [NOT ON MAP]"
          @on_map = false
      else
        # Not present, add it
        console.log("#{@node.id} NOT found in node_collection, register it.")
        Map.node_collection.register(this)
        if !@on_map
          console.log("Previous node was not on map. We display the marker.", @node)
          Map.map.addLayer(@marker)
          console.log "<#{@character_names}> [ON MAP]"
          @on_map = true
      @update_marker()
      
  # Return the content of the popup of the marker.
  # Must be null to not create a popup
  popup_content: ->
    popup_container = $('<div />');
    __this = this
    popup_container.on('click', '.js-leave-node', ->
      $this = $(this)
      character_id = $this.data('character-id')
      spacetime_position_id = $this.data('node-id')
      __this.restore_point()
      __this.delete_presence_on_server(character_id, spacetime_position_id)
    )
    popup_container.on('click', '.js-edit-node', ->
      __this.edit_node()
    )
    if @node.real
      if @owned
        edit_button = '<small><span class="glyphicon glyphicon-pencil map-edit-node js-edit-node"></span></small>'
        if window.blank(@node.title)
          popup_container.append("<h4>"+edit_button+"</h4>")
        else
          popup_container.append("<h4>#{@node.title} #{edit_button}</h4>")
      else
        popup_container.append("<h4>#{@node.title}</h4>") if !window.blank(@node.title)
      popup_container.append("<p>#{@node.resume}</p>") if !window.blank(@node.resume)
      if @node.topic_id
        topic = Map.topics_by_id[@node.topic_id]
        console.log(topic)
        if topic.nb_answers > 1
          plural="s"
        else
          plural=""
        popup_container.append("<p><small><a href='#{Map.topics_url}/#{@node.topic_id}'>Lire le sujet</a> (#{topic.nb_answers} réponse#{plural})</small></p>")
        if topic.last_answered_by
          popup_container.append("<p><small>Dernière réponse par #{topic.last_answered_by} le #{window.j_date(topic.last_answered_at).format('french2')}</small></p>")
        
      else
        params = {
          spacetime_position_id: @node.id,
        }
        popup_container.append("<p><small><a href='#{Map.topics_url}/new?#{$.param(params)}'>Créer un sujet</a></small></p>")
    if !window.blank(@character_names)
      str = "<small>" 
      first = true
      for character, ind in @characters
        if first
          first = false
        else
          str += "& "
        str += character.name + " "
        if @node.real and character.owned
          str += "<button class='js-leave-node btn btn-xs btn-danger' data-character-id=#{character.id} data-node-id=#{@node.id}>x</button> " 
      str += "</small>"
      popup_container.append(str)
    popup_container[0]
    
    
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
        @popup = true
      if @node.real and (not window.blank(@node.title) or not window.blank(@node.resume) or @owned)
        @marker.openPopup()
      else
        @marker.closePopup()
    else
      alert("Woops, not normal.")
      console.log("popup_content must return something, or I'm a fool")
      @destroy_popup()
  update_marker: ->
    @resize_marker()
    @update_popup()
    @update_latlng()
    
  # Destroy popup and marker
  destroy: ->
    @destroy_popup()
    console.log "Destroy node <#{@node.id}>:"
    if fetch = Map.node_collection.fetch(@node.id)
      console.log "Found in node_collection, remove from node_collection"
      Map.node_collection.remove(this)
      if fetch != this
        console.log "Fetched was different from current node destroyed, so destroy fetched"
        fetch.destroy()
    if @on_map
      console.log "Destroy node <#{@node.id}>: On map : Remove marker."
      Map.map.removeLayer(@marker)
      console.log "<#{@character_names}> [NOT ON MAP]"
      @on_map = false
      
  # Idem + on server
  really_destroy: (callback) ->
    @delete_on_server(callback)
    @destroy()
    
  # Fetch characters model by @node.character_ids
  # Calculate @character_names
  update_characters: ->
    @characters = []
    @owned = false
    @owned_characters = []
    for ch_id in @node.character_ids
      ch = Map.character_list.characters_by_id[ch_id]
      @characters.push(ch)
      @owned ||= ch.owned
      if ch.owned
        @owned_characters.push(ch)
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
  remove_character: (id, callback)->
    @restore_point()
    if @node.character_ids.length <= 1
      console.log("really destroy node", @node.id)
      @really_destroy(callback)
    else
      # Remove character id from @node.character_ids
      console.log("Remove character #{id} from", @node.character_ids)
      ind = 0
      while (ind = @node.character_ids.indexOf(id)) != -1
        @node.character_ids.splice(ind, 1)
      @update_characters()
      @update_on_server(callback)
  
  node2spacetime_position: (node) ->
    spacetime_position = $.extend({}, node)
    delete spacetime_position.created_at
    delete spacetime_position.updated_at
    delete spacetime_position.user_id
    delete spacetime_position.birth
    delete spacetime_position.real
    spacetime_position
  # Update @node on server
  update_on_server: (callback) ->
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
          if callback
            callback()
        error: (xhr) =>
          if xhr.responseJSON and xhr.responseJSON.errors and xhr.responseJSON.errors.base
            alert "Error: "+xhr.responseJSON.errors.base[0]
          else
            alert "Error on server ! Node #{@node.id} can't be updated."
          @restore_node()
    else
      alert("update a non real node !")
      @restore_node()
  # Create @node on server
  create_on_server: (callback) ->
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
        if callback
          callback()
      error: (xhr) =>
        if xhr.responseJSON and xhr.responseJSON.errors and xhr.responseJSON.errors.base
          alert "Error: "+xhr.responseJSON.errors.base[0]
        else
          alert "Error on server ! Node #{@node.id} can't be created."
        @restore_node()
  # Update @node on server
  delete_on_server: (callback) ->
    alert("delete a non real node !") unless @node.id != 0
    $.ajax
      type: "DELETE"
      url: "/spacetime_positions/"+@node.id
      dataType: "json"
      success: =>
        console.log "Node #{@node.id} deleted on server."
        @old_node = null
        if callback
          callback()
      error: =>
        alert "Error on server ! Node #{@node.id} can't be deleted."
        @restore_node()
  # Delete a presence on server (leave a spacetime position)
  delete_presence_on_server: (character_id, spacetime_position_id) ->
    $.ajax
      type: "POST"
      url: "/characters/"+character_id+"/destroy_presence"
      dataType: "json"
      data: 
        spacetime_position_id: spacetime_position_id
      success: =>
        console.log "Presence of #{character_id} @ #{spacetime_position_id} deleted on server."
        @old_node = null
      error: =>
        alert "Error on server ! Presence of #{character_id} @ #{spacetime_position_id} can't be deleted."
        @restore_node()