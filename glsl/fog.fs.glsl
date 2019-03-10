#version 300 es

out vec4 out_FragColor;

uniform float fogDensity;
uniform vec3 lightDirectionUniform;
uniform vec3 lightColorUniform;
uniform float kDiffuseUniform;
uniform vec3 lightFogColorUniform;

in vec4 pos;
in mat3 normMat;
in vec3 norm;
in mat4 view;


void main() {

	// TODO: PART 1C

	float distanceToCamera = length(pos);

	vec4 l = normalize(view * vec4(lightDirectionUniform, 0.0));
	vec4 n = normalize(vec4(normMat * norm, 0.0));

	//DIFFUSE
	float cosTheta = dot(l, n);
	vec3 light_DFF = kDiffuseUniform * lightColorUniform * max(0.0, cosTheta);

	float fogLevel = 1.0 / exp(distanceToCamera * fogDensity);

	vec3 lightFogColor = (1.0 - fogLevel) * lightFogColorUniform;

	vec3 color = light_DFF * fogLevel + lightFogColor;

	out_FragColor = vec4(clamp(color, 0.0, 1.0), 1.0);
}
