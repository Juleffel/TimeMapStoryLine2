sigma.publicPrototype.loadData = function ($data_container) {
  var sigInst = this;
  
  /*** NODE AND EDGE INSTANTIATION ***/
  var nodes_by_id = $data_container.data('nodes-by-id');
  var links_by_id = $data_container.data('links-by-id');
  var type_links_by_id = $data_container.data('type-links-by-id');
  var type_nodes_by_id = $data_container.data('type-nodes-by-id');
  sigInst.modifiable_node_ids = $data_container.data('modifiable-node-ids');

  /* NODES */
  for (var type_node_id in type_nodes_by_id) {
    var type_node = type_nodes_by_id[type_node_id];
    var color = type_node.color || sigInst.defaultColor;
    var node_ids = type_node.node_ids;
    for (node_id_ind in node_ids) {
      var node_id = node_ids[node_id_ind];
      var node = nodes_by_id[node_id];
      var g_node = {
        label: node.name,
        color: color,
        size: node.importance
      }; // Create basic node
      
      /* Add other attributes to node */
      g_node['temp'] = []; // These attributes will be not displayed as character information !
      g_node['temp']['node_id'] = node.id;
      g_node['temp']['type_node_id'] = type_node_id;
      g_node['temp']['true_color'] = color;
      g_node['temp']['depth'] = node.depth;

      sigInst.addNode('n' + node.id, g_node);
      //console.log("addNode:", g_node);
    }
  }

  /* EDGES */
  for (var type_link_id in type_links_by_id) {
    var type_link = type_links_by_id[type_link_id];
    var color = type_link.color || sigInst.defaultColor;
    var link_ids = type_link.link_ids;
    for (link_id_ind in link_ids) {
      var link_id = link_ids[link_id_ind];
      var link = links_by_id[link_id];
      var g_edge = {
        id: link.id,
        sourceID: link.node_from_id,
        targetID: link.node_to_id,
        label: link.name,
        color: color
      }; // Create basic edge

      /* Add character attributes to node */
      g_edge['weight'] = link.strengh / 40;

      /* Add other attributes to node */
      g_edge['temp'] = []; // These attributes will be not displayed as character information !
      g_edge['temp']['type_link_id'] = type_link_id;
      g_edge['temp']['true_color'] = color;

      sigInst.addEdge(
        'l' + link.id,
        'n' + link.node_from_id,
        'n' + link.node_to_id,
        g_edge
      );
      //console.log("addEdge:", g_edge);
    }
  }
  sigInst.draw();
  
  /*** END : NODE AND EDGE INSTANTIATION ***/
};