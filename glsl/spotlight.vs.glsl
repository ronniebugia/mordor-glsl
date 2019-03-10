#version 300 es

uniform vec3 spotlightPosition;
uniform vec3 spotDirectPosition;

out vec4 lightVector;
out vec4 pos;

out mat3 normMat;
out vec3 norm;
out mat4 view;
out vec4 posInWorld;

void main() {

 	// TODO: PART 1D
  lightVector = vec4(spotDirectPosition - spotlightPosition, 0.0);
  pos = modelMatrix * vec4(position, 1.0) - vec4(spotlightPosition, 1.0);

  
  normMat = normalMatrix;
  norm = normal;
  view = viewMatrix;
  posInWorld = modelMatrix * vec4(position, 1.0);


  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}