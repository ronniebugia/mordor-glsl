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


	//TOTAL INTENSITY

	vec4 v = normalize(pos);
	vec4 l = normalize(view * vec4(lightDirectionUniform, 0.0));
	vec4 n = normalize(vec4(normMat * norm, 0.0));
	

	//AMBIENT
	vec3 light_AMB = ambientColorUniform * kAmbientUniform;

	//DIFFUSE
	float cosTheta = dot(l, n);
	vec3 light_DFF = kDiffuseUniform * lightColorUniform * max(0.0, cosTheta);

	//SPECULAR
	vec4 bounce = reflect(l, n);

    float cosAlpha = dot(v, bounce);

	vec3 light_SPC = kSpecularUniform * lightColorUniform * pow(max(0.0, cosAlpha), shininessUniform);

	//TOTAL
	vec3 TOTAL = light_AMB + light_DFF + light_SPC;

	//TODO PART 1E: calculate light intensity (ambient+diffuse+speculars' intensity term)
	float lightIntensity = length(TOTAL) / 3.0;
	
	vec4 resultingColor;

	//TODO PART 1E: change resultingColor based on lightIntensity (toon shading)
	if (lightIntensity > 0.85)
		resultingColor = vec4(0.0, 0.0, 0.95,1.0);
	else if (lightIntensity > 0.75)
		resultingColor = vec4(0.0, 0.0, 0.8,1.0);
	else if (lightIntensity > 0.65)
		resultingColor = vec4(0.0, 0.0, 0.7,1.0);
	else if (lightIntensity > 0.35)
		resultingColor = vec4(0.0, 0.0, 0.6,1.0);
	else if (lightIntensity > 0.15)
		resultingColor = vec4(0.0, 0.0, 0.4,1.0);
	else if (lightIntensity > 0.10)
		resultingColor = vec4(0.0, 0.0, 0.35,1.0);
	else 
		resultingColor = vec4(0.0, 0.0, 0.25,1.0);


   	//TODO PART 1E: change resultingColor to silhouette objects

	if(dot(-v, n) < radians(25.0)){
		resultingColor = vec4(0.0, 0.0, 0.0, 1.0);
	}
	   
	
	out_FragColor = resultingColor;
}
