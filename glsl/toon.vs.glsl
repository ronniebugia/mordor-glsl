
#version 300 es

uniform float kDiffuseUniform;
uniform float kSpecularUniform;
uniform float kAmbientUniform;
uniform vec3 lightDirectionUniform;
uniform vec3 lightColorUniform;
uniform vec3 ambientColorUniform;
uniform float shininessUniform;


out mat3 normMat;
out vec3 norm;
out mat4 model;
out mat4 view;
out vec4 pos;

void main() {
	// TODO: PART 1E


    //PHONG MATETRIAL
    // LIGHT INTESNITY BREAK INTO CASES

    // THRESHOLD 0.3 
    // DOT (view , vertex)

    normMat = normalMatrix;
    norm = normal;

    model = modelMatrix;
    view = viewMatrix;

    pos = modelViewMatrix * vec4(position, 1.0);


    
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}