import QtQuick 2.0

Rectangle {
    id: rect
    width: 360
    height: 360
    color: "#00B000"
    
    ShaderEffect {
        width: rect.width
        height: rect.height
        property real scale: 0.01
        
        fragmentShader: "
            varying vec2 qt_TexCoord0;
            uniform float qt_Opacity;
            uniform float width;
            uniform float height;
            uniform float scale;

            void main() {
                vec2 p = (qt_TexCoord0 - 0.5) * vec2(width, height) * scale;
                vec2 z = p;
                int i;
                int count = 100;
                for (i = 0; i < count; ++i) {
                    vec2 z2;
                    z2.x = z.x * z.x - z.y * z.y + p.x;
                    z2.y = 2.0 * z.x * z.y + p.y;
                    if (length(z2) > 4.0) break;
                    z = z2;
                }
                
                float value = (i == count) ? 0.0 : float(i) / float(count);

                gl_FragColor = vec4(value, value, value, 1.0);
            }"
    }
}
