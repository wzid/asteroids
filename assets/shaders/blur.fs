extern float weights[50];
extern vec2 dir, texel_size;
extern int radius;

#define offset texel_size * dir

vec4 effect(vec4 color, Image tex, vec2 coords, vec2 _) {
    vec3 c = Texel(tex, coords).rgb * weights[0];
    float total_weight = weights[0];
    for (float f = 1.0; f <= radius; f++) {
        c += Texel(tex, coords + f * offset).rgb * weights[int(abs(f))];
        c += Texel(tex, coords - f * offset).rgb * weights[int(abs(f))];

        total_weight += (weights[int(abs(f))]) * 2.0;
    }

    return vec4(c.rgb / total_weight, 1.0);
}