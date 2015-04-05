window.getZIndex = function (e) {      
  var z = window.document.defaultView.getComputedStyle(e).getPropertyValue('z-index');
  if (isNaN(z)) return window.getZIndex(e.parentNode);
  return z; 
};