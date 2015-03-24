sigma.publicPrototype.showNodeinfo = function (node_id) {
  /* Method which display information according to the selected node */
  var sigInst = this;
  sigInst.focusedNode = node_id;
  sigInst.selectNodes([node_id]);
  //centerNode(node_id);
  // Open Popup
  $popup = $('.nodeinfo.' + node_id);
  if ($popup.length) {
    $popup.addClass('active');
    $('.fullscreen').addClass('to-right');
    sigInst.position(init_x, init_y, zoom_min);
    sigInst.activateFishEye().draw();
  }
};

sigma.publicPrototype.hideNodeinfo = function () {
  var sigInst = this;
  sigInst.iterNodes(function (n) { // Iterate node to update the search box according to the selected node name
    if (n.id != sigInst.focusedNode) {
      n.attr.temp.forceVisible = false;
    }
  });
  sigInst.focusedNode = null;
  sigInst.deselectNodes();
  $('.nodeinfo').removeClass('active');
  $('.fullscreen').removeClass('to-right');
  sigInst.deactivateFishEye().updateTypeNodeFilter();
};

sigma.publicPrototype.nodeInfoLinksInit = function () {
  var sigInst = this;
  $('.select-node').each(function () {
    var $this = $(this);
    var clicked = false;
    $this.click(function (e) {
      sigInst.hideNodeinfo();
      var id = $this.attr('node');
      sigInst.showNodeinfo(id);
      clicked = true;
      e.preventDefault();
      return false;
    });
    $this.mouseenter(function () {
      var id = $this.attr('node');
      sigInst.selectNodes([id]);
    });
    $this.mouseleave(function () {
      if (clicked) {
        clicked = false;
      } else {
        var id = $this.parents('.nodeinfo').attr('node');
        sigInst.selectNodes([id]);
      }
    });
  });
};
