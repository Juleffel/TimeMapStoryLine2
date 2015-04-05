###########################
# Structure to gathering node_objs
###########################
class Map.NodeCollection # Not RockCollection, man
  constructor: () ->
    # Initiate the hash table
    @node_objs_by_id = {}
    @node_objs = []
  
  # [ Called by node_obj creation, node_obj maj
  register: (node_obj)-> 
    #console.log("nc: register", node_obj.node.id)
    @node_objs.push(node_obj)
    id = node_obj.node.id
    if id
      @node_objs_by_id[id] = node_obj
    
  # [ Called by node_obj_maj, node_obj_destruction
  remove: (node_obj) ->
    #console.log("nc: remove", node_obj.node.id)
    id = node_obj.node.id
    if id
      @node_objs_by_id[id] = null
      delete @node_objs_by_id[id]
    # Remove node_obj from @node_objs
    index = -1
    for nd_obj, ind in @node_objs
      if nd_obj == node_obj
        index = ind
    if (index > -1)
      @node_objs.splice(index, 1)
    
  # [ Called before register
  fetch: (id) ->
    #console.log("nc: fetch", id)
    node_obj = @node_objs_by_id[id]
    if node_obj
      node_obj
    else
      null
      
  # [ Called by d&d, at end, we add character1 to node_obj2
  closest: (node_obj) ->
    closest = null
    PONAK_CONS = 1000000000
    scale = L.CRS.scale(Map.map.getZoom())
    dist = PONAK_CONS/scale  # In meters, Dependent of zoom
    for n_obj in @node_objs
      if n_obj.node.id != node_obj.node.id
        cur_dist = node_obj.distance_from(n_obj)
        if cur_dist < dist
          closest = n_obj
          dist = cur_dist
    closest