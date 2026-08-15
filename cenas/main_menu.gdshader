shader_type canvas_item;

uniform vec4 shine_color : source_color = vec4(1.0, 1.0, 1.0, 0.5);
uniform float speed : hint_range(0.1, 8.0) = 1.0;
uniform float width : hint_range(0.01, 1.0) = 0.2;

void fragment() {
    // IMPORTANTE: usar color sem precisar d uma variavel so p isso
    // vai considerar tudo
    vec4 input_color = COLOR;

    
    // brilho
    // desing
    float shine = sin((UV.x + UV.y) * 5.0 - TIME * speed * 5.0);
    
    if (input_color.a > 0.0 && shine > 1.0 - width) {
        float intensity = (shine - (1.0 - width)) / width;
        // fax mix do shader c o inspetor
        COLOR = mix(input_color, shine_color, intensity * shine_color.a);
    } else {
        COLOR = input_color;
    }
}

uniform float offset : hint_range(0.0, 0.05) = 0.005;

  