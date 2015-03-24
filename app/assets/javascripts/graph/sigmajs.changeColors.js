/*** GREY COLOR FOR NOT SELECTED NODES ***/
sigma.publicPrototype.changeColors = function (nodes) {
  var sigInst = this;
  var deselectColor = sigInst.deselectColor;
  if (nodes == null) { // If there is no selected node
    sigInst.iterNodes(function (n) { // Iterate nodes to give them their default color
      n.color = n.attr.temp.true_color;
    }).iterEdges(function (e) { // Iterate nodes to give them their default color
      e.color = e.attr.temp.true_color;
    }).draw();
  } else { // If a node is selected
    var neighbors = {};
    neighbors[nodes[0]] = 1; // The selected node is also stored as its neighbor
    sigInst.iterEdges(function (e) { // Iterate edges...
      if (nodes.indexOf(e.source) < 0 && nodes.indexOf(e.target) < 0) { // If this is not a link from the node of interest,
        e.color = deselectColor; // We deselect the edge
      } else { // Else,
        // We display the edge and we store the concerned nodes as neighbors
        e.color = e.attr.temp.true_color;
        neighbors[e.source] = 1;
        neighbors[e.target] = 1;
      }
    }).iterNodes(function (n) { // Iterate nodes to display every neighbor with the default color and deselect the others
      if (!neighbors[n.id]) {
        n.color = deselectColor;
      } else {
        n.color = n.attr.temp.true_color;
      }
    }).draw();
  }
};