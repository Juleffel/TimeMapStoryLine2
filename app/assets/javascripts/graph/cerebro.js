//= require graph/sigmajs.loadData
//= require graph/sigmajs.searchNode
//= require graph/sigmajs.fisheye
//= require graph/sigmajs.circularLayout
//= require graph/sigmajs.changeColors
//= require graph/sigmajs.selectNodes
//= require graph/sigmajs.buttonFilters
//= require graph/sigmajs.nodesInfo
//= require graph/sigmajs.layoutButtons
//= require graph/sigmajs.events

function init() {
	/*** VARIABLES ***/
	zoom_min = 0.9;
	zoom_max = 4;
	init_x = -24;
	init_y = 42;
	
	cerebro = document.getElementById('js-graph');
	if (cerebro == null) return;
	
	/*** CEREBRO INSTANTIATION ***/
	//var defaultColor = 'rgb(119,221,119)';
	
	$cerebro = $(cerebro);
	$cerebro_offset = $cerebro.offset();
	var sigInst = sigma.init(cerebro).drawingProperties({
		defaultLabelColor: '#fff',
		defaultLabelSize: 14,
		defaultLabelBGColor: '#fff',
		defaultLabelHoverColor: '#000',
		labelColor: "node",
		labelThreshold: 3,
		defaultEdgeType: 'curve'
	}).graphProperties({
		minNodeSize: 1,
		maxNodeSize: $cerebro.attr('max_node_size') || 10,
		minEdgeSize: 1,
		maxEdgeSize: $cerebro.attr('max_edge_size') || 2,
	}).mouseProperties({
		maxRatio: zoom_max, // Max zoom
		minRatio: zoom_min // Max dezoom
	});
	sigInst.deselectColor = '#000';
	sigInst.focusedNode = null;
  sigInst.delayForceAtlas = 5;
  sigInst.defaultColor = '#fff';
	/*** END : CEREBRO INSTANTIATION ***/

	/*** LAUNCH MODULES ***/
	sigInst.loadData($cerebro);
  sigInst.deactivateFishEye();
	sigInst.circularLayout();
	sigInst.startForceAtlas2();
  sigInst.searchNode();
	sigInst.typeNodeFilter();
	sigInst.typeLinkFilter();
	sigInst.layoutButtons();
  sigInst.bindEvents($cerebro);
  sigInst.nodeInfoLinksInit();
	/*** END : LAUNCH MODULES ***/
	/*setInterval(function() {
	  console.log(sigInst.position());
	}, 100);*/
}

if (document.addEventListener) {
	document.addEventListener('DOMContentLoaded', init, false);
} else {
	window.onload = init;
}