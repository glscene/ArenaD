uniform sampler2D BaseTex;
varying vec2 vT;
void main(){
  vec4 p1 = texture2D(BaseTex, gl_TexCoord[0].xy) * vT.x;
  vec4 p2 = texture2D(BaseTex, gl_TexCoord[1].xy) * vT.y;
  gl_FragColor = p1 + p2;
}