###############################
# A character is the character and its nodes
# @character: Character model from server
# @nodes: Array of nodes model from server
# @date: date of the map, this character print his marker according to this date
# @node: Fake node(spacetime_position) model with properties calculate by @date
# @node_obj: class Node object corresponding to the marker, calculate and updated according to @node
#
#######################
##### Map of calls ####
#######################
#
#### Entry points ###
#
#-> destroy
#
#-> new Map.Character(new_ch) -> create_marker, update_nodes (load @nodes)
#
#-> update_character(new_ch)
#|-> update_character_nodes(new_ch) -> update_nodes (load @nodes), update_node_obj
#
#-> update_date(new_date) -> update_node_obj
#
#### Sub-functions ###
#
#update_node_obj
#  -> choose_node, 
#  -> change_node | create_node_obj | update_node_obj_position | destroy_node_obj (refresh @node_obj)
#
#choose_node
#  -> set @next_node_index from @date, @nodes
#
#change_node
#  -> update_node_obj_position
#  -> set @last_node_index from @next_node_index
#  
#create_node_obj
#  -> get @node from @next_node_index
#  -> set @node.real
#  -> create @node_obj from @node -> new Node(@node)
#  -> set @last_node_index from @next_node_index
#
#update_node_obj_position
#  -> set @node.real
#  -> calc @node.latitude, longitude
#  -> @node_obj.update_node
#
###############################
class Map.Character
  # Create the character
  # He has'nt date, so he has'nt node_obj at the beginning
  constructor: (@character) ->
    @update_nodes()
    
  # Delete the @node_obj
  destroy_node_obj: ->
    console.log("Remoooooove!")
    if @node_obj
      @node_obj.destroy()
      delete @node_obj
  destroy: ->
    @destroy_node_obj()
  
  update_character: (ch) ->
    @character = ch
    @update_icons()
    @update_character_nodes(ch)
  # Refetch nodes, remove node_obj and recreate it
  update_character_nodes: (ch) ->
    @destroy_node_obj()
    @character = ch
    @update_nodes()
    @update_node_obj()
  # Take @character.node_ids and fetch nodes from nodes_by_id
  
  update_nodes: ->
    @last_node_index = -1
    @next_node_index = -1
    @nodes = []
    begin_at = null
    for node_id in @character.node_ids
      node = Map.nodes_by_id[node_id]
      # Rely on default_scope order(:begin_at) of spacetime_positions (/!\DANGEROUS)
      # So verfiy order here, just in case (because I know I will change the backend randomly, in two years..).
      if !!begin_at and node.begin_at < begin_at
        alert("ERROR: The node_ids of #{@character.name} are not ordered by begin_at !")
      begin_at = node.begin_at
      @nodes.push(node)
      
  # Change the date of the character ->
  # it updates his node with this date
  update_date: (new_date) ->
    @date = new_date
    @update_node_obj()
  # Updates all the properties of a character, even his descriptions and nodes
  # WARNING : For the moment, do exactly the same than the next function.
  # Reflection needed.
  
  # Update @node to correspond with the date and update or recreate 
  update_node_obj: ->
    @choose_node()
    if @next_node_index != -1
      #console.log "Choosed node: #{@nodes[@next_node_index].id} -> #{@nodes[@next_node_index].title}"
      if @last_node_index != @next_node_index
        if @node_obj
          # node has changed
          @change_node()
        else
          # first time
          @create_node_obj()
      else
        # Same node as before
        @update_node_obj_position()
    else
      console.log "No node for this date. (Before birth.)"
      @destroy_node_obj()
      
  # Update @next_node_index with the index of the node just before the date,
  # or the first node if the date is before
  choose_node: ->
    if @date && @nodes.length > 0
      node_index = 0
      # Functions
      search_forward = =>
        while @nodes[node_index+1] && (@nodes[node_index+1].begin_at <= @date)
          node_index += 1
      search_backward = =>
        while @nodes[node_index-1] && (@nodes[node_index-1].begin_at > @date)
          node_index -= 1
        if @nodes[node_index-1]
          node_index -= 1
      # Core
      if @last_node_index == -1
        search_forward()
      else
        node_index = @last_node_index
        if (@nodes[node_index].begin_at < @date)
          search_forward()
        else
          search_backward()
      @next_node_index = node_index
    else
      @next_node_index = -1
    
  # Read @next_node_index and create a @node_obj
  create_node_obj: ->
    if @next_node_index != -1
      # Copy the node in a new object
      node = $.extend({}, @nodes[@next_node_index])
      if node.begin_at <= @date && node.end_at >= @date
        # Date is between nood.begin_at and node.end_at
        node.real = true
      else
        node.real = false
        node.character_ids = [@character.id]
        node.id = -@character.id
      @node_obj = new Map.Node(node)
      console.log "MapNode created:", @node_obj
    @last_node_index = @next_node_index
    
  # Update content and position of @node and @node_obj
  # @node_obj must exists
  change_node: ->
    @update_node_obj_position()
    @last_node_index = @next_node_index
    
  # Update position of @node and @node_obj
  # @node_obj must exists
  # @node.begin_at = @date if between @nodes[@next_node_index].begin_at and @nodes[@next_node_index+1].begin_at
  #   So, if it is < @nodes[@next_node_index].end_at, it is a real node, possibly updatable, maybe with a topic
  #   Else, it's a not real @node, it doesn't exist in backend and is only here to make the link, the traject, between two real nodes.
  update_node_obj_position: ->
    node = $.extend({}, @nodes[@next_node_index])
    suiv_node = @nodes[@next_node_index+1]
    cur_node = @nodes[@next_node_index]
    cur_lat = cur_node.latitude
    cur_lng = cur_node.longitude
    node.real = false
    if !suiv_node || cur_node.end_at >= @date
      if cur_node.begin_at <= @date && cur_node.end_at >= @date
        node.real = true
      new_lat = cur_lat
      new_lng = cur_lng
    else
      # We are between two nodes
      diff_lat = suiv_node.latitude - cur_lat
      diff_lng = suiv_node.longitude - cur_lng
      diff_dates = suiv_node.begin_at - cur_node.end_at
      diff_dates_current = @date - cur_node.end_at
      if diff_dates == 0
        # Nodes times are touching each other (Teleportation)
        # Whoops ! Warning: Div by 0 !
        new_lat = cur_lat
        new_lng = cur_lng
      else
        new_lat = cur_lat + diff_lat * (diff_dates_current/diff_dates)
        new_lng = cur_lng + diff_lng * (diff_dates_current/diff_dates)
      #console.log("char:", @character.name)
      #console.log('latlng:', cur_lat, cur_lng, new_lat, new_lng)
      #console.log('diffs:', diff_lat, diff_lng, diff_dates, diff_dates_current)
    node.latitude = new_lat
    node.longitude = new_lng
    if not node.real
      node.character_ids = [@character.id]
      node.id = -@character.id
    @node_obj.update_node(node)
    
  # Update the character on the server ### WARNING ! Theorically NEVER CALLED
  # TODO DELETE
  ###
  update_on_server: ->
    alert("UPDATE CHARACTER ON SERVER. NOT LOGICAL")
    $.ajax
      type: "PUT"
      url: "/characters/"+@character.id
      data: 
        character: @character
      dataType: "json"
      success: =>
        console.log "Character #{@id} updated on server."
      error: =>
        alert "Error on server ! Character #{@id} update failed."
  ###