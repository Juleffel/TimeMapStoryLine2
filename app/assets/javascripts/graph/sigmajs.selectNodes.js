/* Highlight a node and forced it visible if it is hidden. */
sigma.publicPrototype.selectNodes = function (nodes) {
  var sigInst = this;
  var node;
  sigInst.iterNodes(function (n) {
    // Iterate node to find the node clicked
    if (n.id == nodes[0]) {
      node = n;
    }
  });
  if (node.hidden) {
    node.attr.temp.forceVisible = true;
    sigInst.updateTypeNodeFilter();
  }
  sigInst.changeColors(nodes);
  // We change the graph color according to the selected node
};

/* If a node was focused, re-higlight it, else higlight all nodes. */
sigma.publicPrototype.deselectNodes = function () {
  var sigInst = this;
  sigInst.searchNodeValue(""); // If a search was in course, remove it
  if (sigInst.focusedNode) {
    sigInst.changeColors([sigInst.focusedNode]);
  } else {
    sigInst.changeColors(null); // We give the default colors
  }
};