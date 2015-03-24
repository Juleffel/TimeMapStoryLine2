/*** FILTERS ***/
// No filter
sigma.publicPrototype.noFilter = function () {
  this.iterNodes(function (n) { // Iterate nodes to display them
    n.hidden = false;
  }).iterEdges(function (e) { // Iterate edges to display them
    e.hidden = false;
  }).draw();
};

sigma.publicPrototype.nodeIsVisible = function(node, ratio) {
  return ratio >= zoom_min + node.attr.temp.depth * 0.5;
};

// Node filter
sigma.publicPrototype.updateTypeNodeFilter = function () {
  var sigInst = this;
  var mapFilter = {}; // Variable to know if a filter is activated or not
  $buttons = $('#type_node_filters .tiny-button'); // Retrieve every button corresponding to a node filter
  $buttons.each(function () {
    // Store true or false for each filter value
    mapFilter[$(this).attr('value')] = $(this).hasClass("active");
  });
  sigInst.iterNodes(function (n) { // Iterate nodes...
    if (n.attr.temp.forceVisible) {
      n.hidden = false;
    } else {
      if (mapFilter[n.attr.temp.type_node_id] == false) {
        n.hidden = true;
      } else {
        n.hidden = false;
      }
      if (!sigInst.nodeIsVisible(n, sigInst.position().ratio)) {
        n.hidden = true;
      }
    }
  }).draw();
  sigInst.updateSearchBox(mapFilter);
};

// Link filter
sigma.publicPrototype.updateTypeLinkFilter = function () {
  var sigInst = this;
  var mapFilter = new Object();
  var mapFilter = {}; // Variable to know if a filter is activated or not
  $buttons = $('#type_link_filters .tiny-button'); // Retrieve every button corresponding to a node filter
  $buttons.each(function () {
    // Store true or false for each filter value
    mapFilter[$(this).attr('value')] = $(this).hasClass("active");
  });
  sigInst.iterEdges(function (e) { // Iterate edges...
    if (mapFilter[e.attr.temp.type_link_id] == false) {
      e.hidden = true;
    } else {
      e.hidden = false;
    }
  }).draw();
};

// Add event to type node filters
sigma.publicPrototype.typeNodeFilter = function () {
  var sigInst = this;
  var $buttons = $('#type_node_filters .tiny-button');
  $buttons.each(function () {
    var $element = $(this);
    $element.toggleClass("active");
    $element.click(function () {
      $element.toggleClass("active");
      sigInst.updateTypeNodeFilter();
    });
  });
  sigInst.updateTypeNodeFilter();
};


// Add event to type link filters
sigma.publicPrototype.typeLinkFilter = function () {
  var sigInst = this;
  var $buttons = $('#type_link_filters .tiny-button');
  $buttons.each(function () {
    var $element = $(this);
    $element.toggleClass("active");
    $element.click(function () {
      $element.toggleClass("active");
      sigInst.updateTypeLinkFilter();
    });
  });
  sigInst.updateTypeLinkFilter();
};

/*** END : FILTERS ***/