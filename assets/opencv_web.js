// Inject required JS libraries
injectLibraries();

// to get Contours from an Image
async function getContours(img) {
  var jimpSrc = await Jimp.read(Buffer.from(img));
  var src = cv.matFromImageData(jimpSrc.bitmap);

  // change image threshold
  cv.cvtColor(src, src, cv.COLOR_BGR2GRAY, 0);
  cv.threshold(src, src, 120, 200, cv.THRESH_BINARY);

  let contours = new cv.MatVector();
  let hierarchy = new cv.Mat();

  // get Contours
  cv.findContours(
    src,
    contours,
    hierarchy,
    cv.RETR_TREE,
    cv.CHAIN_APPROX_SIMPLE
  );

  // convert to Json to send back to flutter
  let contoursData = [];

  for (let i = 0; i < contours.size(); ++i) {
    let rect = cv.boundingRect(contours.get(i));

    contoursData.push(
      JSON.stringify({
        x: rect.x,
        y: rect.y,
        w: rect.width,
        h: rect.height,
      })
    );
  }

  let result = JSON.stringify({
    contours: contoursData,
  });

  //dispose all
  src.delete();
  contours.delete();
  hierarchy.delete();
  return result;
}

// Call this function on Top To inject these libraries
function injectLibraries() {
  // Path of assets
  let assetsPath = "./assets/packages/opencv_web/assets";
  // inject OpenCv
  var script = document.createElement("script");
  script.async = true;
  script.src = `${assetsPath}/opencv/opencv.js`;
  script.onload = function () {
    console.log("Opencv loaded");
  };
  document.head.appendChild(script);

  // inject JIMP
  var jimpScript = document.createElement("script");
  jimpScript.src = `${assetsPath}/opencv/jimp.js`;
  document.head.appendChild(jimpScript);
}
