// Has FlxRuntimeShader.BASE_FRAGMENT_HEADER put here //

uniform float alphaShit;

void main() {
    vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
    if (color.a > 0.0) color -= alphaShit;
    
    gl_FragColor = color;
}