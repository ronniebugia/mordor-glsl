// CHECK WEBGL VERSION
if ( WEBGL.isWebGL2Available() === false ) {
  document.body.appendChild( WEBGL.getWebGL2ErrorMessage() );
}

// SETUP RENDERER & SCENE
var container = document.createElement( 'div' );
document.body.appendChild( container );

var canvas = document.createElement("canvas");
var context = canvas.getContext( 'webgl2' );
var renderer = new THREE.WebGLRenderer( { canvas: canvas, context: context } );
renderer.setClearColor(0X808080); 
container.appendChild( renderer.domElement );
var scene = new THREE.Scene();

var loader = new THREE.TextureLoader();
loader.load('images/mordor.jpg' , function(texture)
            {
             scene.background = texture;  
            });

// SETUP CAMERA
var camera = new THREE.PerspectiveCamera(27,1,0.1,1000); // view angle, aspect ratio, near, far
camera.position.set(45,85,550);
camera.lookAt(scene.position);
scene.add(camera);

// SETUP ORBIT CONTROLS OF THE CAMERA
var controls = new THREE.OrbitControls(camera);
controls.damping = 0.2;
controls.autoRotate = false;

// ADAPT TO WINDOW RESIZE
function resize() {
  renderer.setSize(window.innerWidth,window.innerHeight);
  camera.aspect = window.innerWidth/window.innerHeight;
  camera.updateProjectionMatrix();
}

// EVENT LISTENER RESIZE
window.addEventListener('resize',resize);
resize();

//SCROLLBAR FUNCTION DISABLE
window.onscroll = function () {
     window.scrollTo(0,0);
   }

// WORLD COORDINATE FRAME: other objects are defined with respect to it
var worldFrame = new THREE.AxesHelper(5) ;
scene.add(worldFrame);

/////////////////////////////////
//   YOUR WORK STARTS BELOW    //
/////////////////////////////////

/// Parameters defining the light position
var lightColor = new THREE.Color(1.0,1.0,1.0);
var lightFogColor = new THREE.Color(0.5,0.5,0.5);
var ambientColor = new THREE.Color(0.4,0.4,0.4);
var lightDirection = new THREE.Vector3(0.49,0.79, 0.49);
var spotlightPosition = new THREE.Vector3(2, 120, -20);


// Material properties
var kAmbient = 0.4;
var kDiffuse = 0.8;
var kSpecular = 0.8;
var shininess = 10.0;

// Uniforms
var lightColorUniform = {type: "c", value: lightColor};
var lightFogColorUniform = {type: "c", value: lightFogColor};
var ambientColorUniform = {type: "c", value: ambientColor};
var lightDirectionUniform = {type: "v3", value: lightDirection};
var spotlightPosition = {type: "v3", value: spotlightPosition};

var kAmbientUniform = {type: "f", value: kAmbient};
var kDiffuseUniform = {type: "f", value: kDiffuse};
var kSpecularUniform = {type: "f", value: kSpecular};
var shininessUniform = {type: "f", value: shininess};
var fogDensity = {type: "f", value: 0.02};

// Change this with keyboard controls in Part 1.D
var spotDirectPosition = {type: 'v3', value: new THREE.Vector3(0.0,0.0,110.0)};


// Materials

var spotlightMaterial = new THREE.ShaderMaterial({
    uniforms: {
        // TODO: pass in the uniforms you need
        spotlightPosition: spotlightPosition,
        spotDirectPosition: spotDirectPosition,
        kDiffuseUniform: kDiffuseUniform,
        kSpecularUniform: kSpecularUniform,
        kAmbientUniform: kAmbientUniform,
        lightDirectionUniform: lightDirectionUniform,
        lightColorUniform: lightColorUniform,
        ambientColorUniform: ambientColorUniform,
        shininessUniform: shininessUniform,

    }
});

var phongMaterial = new THREE.ShaderMaterial({
    uniforms: {
        kDiffuseUniform: kDiffuseUniform,
        kSpecularUniform: kSpecularUniform,
        kAmbientUniform: kAmbientUniform,
        lightDirectionUniform: lightDirectionUniform,
        lightColorUniform: lightColorUniform,
        ambientColorUniform: ambientColorUniform,
        shininessUniform: shininessUniform,
    },
});

var bPhongMaterial = new THREE.ShaderMaterial({
    uniforms: {
        kDiffuseUniform: kDiffuseUniform,
        kSpecularUniform: kSpecularUniform,
        kAmbientUniform: kAmbientUniform,
        lightDirectionUniform: lightDirectionUniform,
        lightColorUniform: lightColorUniform,
        ambientColorUniform: ambientColorUniform,
        shininessUniform: shininessUniform,
    },
});
var toonMaterial = new THREE.ShaderMaterial({
    uniforms: {
        kDiffuseUniform: kDiffuseUniform,
        kSpecularUniform: kSpecularUniform,
        kAmbientUniform: kAmbientUniform,
        lightDirectionUniform: lightDirectionUniform,
        lightColorUniform: lightColorUniform,
        ambientColorUniform: ambientColorUniform,
        shininessUniform: shininessUniform,
    },
});

var fogMaterial = new THREE.ShaderMaterial({
    uniforms: {
        fogDensity: fogDensity,
        lightDirectionUniform: lightDirectionUniform,
        lightColorUniform: lightColorUniform,
        kDiffuseUniform: kDiffuseUniform,
        lightFogColorUniform: lightFogColorUniform,
    },
});

// LOAD SHADERS
var shaderFiles = [

  'glsl/spotlight.vs.glsl',
  'glsl/spotlight.fs.glsl',
  'glsl/phong.vs.glsl',
  'glsl/phong.fs.glsl',
  'glsl/phong_blinn.vs.glsl',
  'glsl/phong_blinn.fs.glsl',
  'glsl/fog.vs.glsl', 
  'glsl/fog.fs.glsl',
  'glsl/toon.fs.glsl',
  'glsl/toon.vs.glsl',
];

new THREE.SourceLoader().load(shaderFiles, function(shaders) {

  spotlightMaterial.vertexShader = shaders['glsl/spotlight.vs.glsl'];
  spotlightMaterial.fragmentShader = shaders['glsl/spotlight.fs.glsl'];
  phongMaterial.vertexShader = shaders['glsl/phong.vs.glsl'];
  phongMaterial.fragmentShader = shaders['glsl/phong.fs.glsl'];
  bPhongMaterial.vertexShader = shaders['glsl/phong_blinn.vs.glsl'];
  bPhongMaterial.fragmentShader = shaders['glsl/phong_blinn.fs.glsl'];
  fogMaterial.vertexShader = shaders['glsl/fog.vs.glsl'];
  fogMaterial.fragmentShader = shaders['glsl/fog.fs.glsl'];
    toonMaterial.fragmentShader = shaders['glsl/toon.fs.glsl'];
    toonMaterial.vertexShader = shaders['glsl/toon.vs.glsl'];
})


var ctx = renderer.context;
//ctx.getShaderInfoLog = function () { return '' };   // stops shader warnings, seen in some browsers

// LOAD OBJECT
function loadOBJ(file, material, scale, xOff, yOff, zOff, xRot, yRot, zRot) {
  var manager = new THREE.LoadingManager();
          manager.onProgress = function (item, loaded, total) {
    console.log( item, loaded, total );
  };

  var onProgress = function (xhr) {
    if ( xhr.lengthComputable ) {
      var percentComplete = xhr.loaded / xhr.total * 100;
      console.log( Math.round(percentComplete, 2) + '% downloaded' );
    }
  };

  var onError = function (xhr) {
  };

  var loader = new THREE.OBJLoader( manager );
  loader.load(file, function(object) {
    object.traverse(function(child) {
      if (child instanceof THREE.Mesh) {
        child.material = material;
      }
    });

    object.position.set(xOff,yOff,zOff);
    object.rotation.x= xRot;
    object.rotation.y = yRot;
    object.rotation.z = zRot;
    object.scale.set(scale,scale,scale);
    object.parent = worldFrame;
    scene.add(object);

  }, onProgress, onError);
}

// floor
var geoFloor = new THREE.PlaneBufferGeometry( 2000.0, 2000.0 );
var floor = new THREE.Mesh( geoFloor, spotlightMaterial );
floor.rotation.x = - Math.PI * 0.5;
floor.position.set( 0, - 0.05, 0 );
scene.add(floor);



loadOBJ('obj/eye_of_sauron.obj', spotlightMaterial, 1, 0, 0, 0, - Math.PI / 2.0, 0, 0);

//CREATE EYE
var eggGeometry = new THREE.SphereGeometry(1, 40, 32);
var egg = new THREE.Mesh(eggGeometry, spotlightMaterial);
egg.position.set(2, 115, -20);
egg.scale.set(6, 6, 6);
egg.parent = worldFrame;
scene.add(egg);


function addEggs(lightingMaterial){
    for (var i = 100;  i < 250; i++) {
        var offset = 0;
        loadOBJ('obj/bunny.obj', spotlightMaterial, 50, 
              (i % 10 + offset) * 4 - 20, 0, Math.floor(i/4) * 4 - 80, 
              0, 0, 0);
    }
}
addEggs(phongMaterial);


// LISTEN TO KEYBOARD
var keyboard = new THREEx.KeyboardState();
function checkKeyboard() {
      // TODO: add keyboard control to change spotDirectPosition
      if(keyboard.pressed("W"))
        spotDirectPosition.value.z += 10.0;
      else if(keyboard.pressed("S"))
        spotDirectPosition.value.z -= 10.0;
      else if(keyboard.pressed("A"))
        spotDirectPosition.value.x += 10.0;
      else if(keyboard.pressed("D"))
        spotDirectPosition.value.x -= 10.0;


    spotlightMaterial.needsUpdate = true;
    phongMaterial.needsUpdate = true;
    bPhongMaterial.needsUpdate = true;
    toonMaterial.needsUpdate = true;
    fogMaterial.needsUpdate = true;
}

// SETUP UPDATE CALL-BACK
function update() {
  checkKeyboard();
  requestAnimationFrame(update);
  renderer.render(scene, camera);
}

update();

