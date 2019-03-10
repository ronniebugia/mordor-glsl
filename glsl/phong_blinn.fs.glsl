#version 300 es

out vec4 out_FragColor;

uniform float kDiffuseUniform;
uniform float kSpecularUniform;
uniform float kAmbientUniform;
uniform vec3 lightDirectionUniform;
uniform vec3 lightColorUniform;
uniform vec3 ambientColorUniform;
uniform float shininessUniform;


in mat3 normMat;
in vec3 norm;

in mat4 model;
in mat4 view;
in vec4 pos;

void main() {

	//TODO: PART 1B
	
	vec4 v = normalize(pos);
	vec4 l = normalize(view * vec4(lightDirectionUniform, 0.0));
	vec4 n = normalize(vec4(normMat * norm, 0.0));

	//AMBIENT
	vec3 light_AMB = ambientColorUniform * kAmbientUniform;

	//DIFFUSE
	float cosTheta = dot(l, n);
	vec3 light_DFF = kDiffuseUniform * lightColorUniform * max(0.0, cosTheta);

	//SPECULAR
	vec4 h = normalize(l - v);
    float cosAlpha = dot(h, n);

	vec3 light_SPC = kSpecularUniform * lightColorUniform * pow(max(0.0, cosAlpha), shininessUniform);


	//TOTAL
	vec3 TOTAL = light_AMB + light_DFF + light_SPC;
	out_FragColor = vec4(TOTAL, 1.0);
	}