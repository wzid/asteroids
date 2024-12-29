extern vec2 dir;
vec4 effect(vec4 color, Image tex, vec2 coords, vec2 _) {
    vec4 r = Texel(tex, coords - dir);
    vec4 g = Texel(tex, coords + dir);
    vec4 b = Texel(tex, coords + dir);
    return vec4(r.r, g.g, b.b, max(r.a/1.5, b.a));
}