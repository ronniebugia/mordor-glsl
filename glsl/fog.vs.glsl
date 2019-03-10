#version 300 es

uniform float fogDesnity;
uniform vec3 lightDirectionUniform;
uniform vec3 lightColorUniform;
uniform float kDiffuseUniform;
uniform vec3 lightFogColorUniform;

out vec4 pos;
out mat3 normMat;
out vec3 norm;
out mat4 view;

void main() {

	// TODO: PART 1C

    normMat = normalMatrix;
    norm = normal;

    view = viewMatrix;

    pos = modelViewMatrix * vec4(position, 1.0);
   

    gl_Position = projectionMatrix * viewMatrix * modelMatrix * vec4(position,1.0);
}
