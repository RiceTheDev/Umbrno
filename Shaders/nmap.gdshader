shader_type canvas_item;

// Permite atribuir um mapa normal no Inspector
uniform sampler2D normal_map;

void fragment() {
    // Converte os dados da textura em um vetor unitário, com cada canal no intervalo [-1, 1]
    vec3 normal = 2.0 * texture(normal_map, UV).rgb - 1.0;
    NORMAL = normal;
}
