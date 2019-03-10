#version 300 es

precision highp float;
precision highp int;
out vec4 out_FragColor;

in vec4 lightVector;
in vec4 pos;

in mat3 normMat;
in vec3 norm;
in mat4 view;
in vec4 posInWorld;

void main() {

	// TODO: PART 1D

   float spotExponent = 75.0;
   vec3 SpotColor = vec3(1.0, 0.0, 0.0);
   vec3 lightDirectionUniform = vec3(0.49,0.79, 0.49);
   vec3 lightColorUniform = vec3(0.2, 0.2, 0.2);
   vec3 lightFogColorUniform = vec3(0.1, 0.1, 0.1);
   float kDiffuseUniform = 0.4;
   vec3 ambientColorUniform = vec3(0.4, 0.4, 0.4);
   float kAmbientUniform = 0.3;

   float distanceToCamera = length(pos);
	vec4 l = normalize(view * vec4(lightDirectionUniform, 0.0));
	vec4 n = normalize(vec4(normMat * norm, 0.0));
   vec4 v = normalize(pos);

   vec3 color;

	//DIFFUSE
	float cosTheta = dot(l, n);
	vec3 light_DFF = kDiffuseUniform * lightColorUniform * max(0.0, cosTheta);

   //AMBIENT
	vec3 light_AMB = ambientColorUniform * kAmbientUniform;

   //SPECULAR
	vec4 bounce = reflect(l, n);
   float cosAlpha = dot(v, bounce);
	vec3 light_SPC = 0.5 * lightColorUniform * pow(max(0.0, cosAlpha), 1.0);

   //TOTAL
	vec3 TOTAL = light_AMB + light_DFF + light_SPC;

	//TODO PART 1E: calculate light intensity (ambient+diffuse+speculars' intensity term)
	float lightIntensity = length(TOTAL) / 3.0;
	
	vec4 resultingColor;
   if(posInWorld.y > 1.0){
      if (lightIntensity > 0.85)
         resultingColor = vec4(0.95, 0.0, 0.0, 1.0);
      else if (lightIntensity > 0.75)
         resultingColor = vec4(0.8, 0.0, 0.0,1.0);
      else if (lightIntensity > 0.65)
         resultingColor = vec4(0.7, 0.0, 0.0, 1.0);
      else if (lightIntensity > 0.35)
         resultingColor = vec4(0.6, 0.0, 0.0, 1.0);
      else if (lightIntensity > 0.15)
         resultingColor = vec4(0.4, 0.0, 0.0, 1.0);
      else if (lightIntensity > 0.10)
         resultingColor = vec4(0.35, 0.0, 0.0, 1.0);
      else 
         resultingColor = vec4(0.25, 0.0, 0.0, 1.0);

      if(dot(-v, n) < radians(10.0)){
         resultingColor = vec4(0.0, 0.0, 0.0, 1.0);
      }
   }
 
   float dotLight = dot(lightVector, pos) / (length(lightVector) * length(pos));
	float angleLight = acos(dotLight);

   if(angleLight < radians(15.0)){
      color = SpotColor * pow(cos(angleLight), spotExponent);
   }else{
      color = resultingColor.xyz;
   }


   out_FragColor = vec4(color , 1.0);
}