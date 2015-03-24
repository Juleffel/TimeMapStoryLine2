var searchNodeSelector = '#searchNode';
var namesForSearchBox = []; // Variable to store the node names which will be used by the search box for completion

// Update according to filter selection
sigma.publicPrototype.updateSearchBox = function (mapFilter) {
  var sigInst = this;
  sigInst.deselectNodes();
  namesForSearchBox = [];
  sigInst.iterNodes(function (n) { // Iterate nodes to add their names to the search box
    if (mapFilter[n.attr.temp.type_node_id] == true) {
      namesForSearchBox.push({id: n.id, label: n.label});
    }
  });
  var $searchNode = $(searchNodeSelector);
  $searchNode.autocomplete({
    source: namesForSearchBox
  });
};

sigma.publicPrototype.searchNode = function () {
  var sigInst = this;
  var $searchNode = $(searchNodeSelector);
  if ($searchNode.length > 0) {
    // Autocompletion parameters
    $searchNode.autocomplete({
      select: function (event, ui) {
        sigInst.showNodeinfo(ui.item.id);
      }
    }).keyup(function (e, ui) {
      if (e.keyCode == 13) { // System to handle the use of the "Enter" key
        var labels = namesForSearchBox.map(function(elem) {
          return elem.label;
        });
        if (labels.indexOf($searchNode.val()) < 0) { // If the current value does not correspond to a node name, we consider this as an expected deselection
          $searchNode.autocomplete("close");
          sigInst.hideNodeinfo();
        }
      }
    });
  }
};

sigma.publicPrototype.searchNodeValue = function (val) {
  var $searchNode = $(searchNodeSelector);
  if ($searchNode.length > 0) {
    $searchNode.val(val);
  }
};
