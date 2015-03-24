sigma.publicPrototype.circularLayout = function (rand) {
  var R = 100,
    L = this.getNodesCount();
  if (rand === undefined) {
    rand = true;
  }
  var shuffle = function(o) { //v1.0
      for(var j, x, i = o.length; i; j = Math.floor(Math.random() * i), x = o[--i], o[i] = o[j], o[j] = x);
      return o;
  };
  node_nums = [];
  for (var ind = 0; ind < L; ind++) {
    node_nums.push(ind);
  }
  if (rand) {
    node_nums = shuffle(node_nums);
  }
  this.iterNodes(function (n) {
    var ind = node_nums.pop();
    n.x = Math.cos(2 * Math.PI * ind / L) * R; // Biology is logical, math is magical...
    n.y = Math.sin(2 * Math.PI * ind / L) * R;
  });

  return this.position(init_x, init_y, zoom_min).draw();
};