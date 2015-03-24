sigma.publicPrototype.layoutButtons = function () {
  var sigInst = this;
  
  if (document.getElementById('circular')) {
    document.getElementById('circular').addEventListener('click', function () {
      sigInst.circularLayout();
    }, true);
  }

  // Run forceatlas
  var isRunning = true;
  setTimeout(function () {
    isRunning = false;
    sigInst.stopForceAtlas2();
    document.getElementById('forceAtlas').childNodes[0].nodeValue = 'Restart Layout';
  }, sigInst.delayForceAtlas * 1000);
  if (document.getElementById('forceAtlas')) {
    document.getElementById('forceAtlas').addEventListener('click', function () {
      if (isRunning) {
        isRunning = false;
        sigInst.stopForceAtlas2();
        document.getElementById('forceAtlas').childNodes[0].nodeValue = 'Restart Layout';
      } else {
        isRunning = true;
        sigInst.startForceAtlas2();
        sigInst.deactivateFishEye();
        document.getElementById('forceAtlas').childNodes[0].nodeValue = 'Stop Layout';
      }
    }, true);
  }

  // Button fish eye
  var fishEyeOn = false;
  if (document.getElementById('fishEye')) {
    document.getElementById('fishEye').addEventListener('click', function () {
      if (fishEyeOn) {
        fishEyeOn = false;
        sigInst.deactivateFishEye();
        document.getElementById('fishEye').childNodes[0].nodeValue = 'Put Fish Eye ON';
      } else {
        fishEyeOn = true;
        if (Math.abs(sigInst.position().ratio - minRatio) <= deltaRatio)
          sigInst.activateFishEye();
        document.getElementById('fishEye').childNodes[0].nodeValue = 'Put Fish Eye OFF';
      }
    }, true);
  }
};