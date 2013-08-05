import QtQuick 2.0

Rectangle {
    id: rect
    width: 360
    height: 360
    color: "#00B000"
    
    ShaderEffect {
        id: mandelbrot
        anchors.fill: parent
        property real scale: 0.01
        property real scaleOrigin: 0.01
        
        property real offsetX: 0
        property real offsetY: 0
        
        fragmentShader: "
            varying vec2 qt_TexCoord0;
            uniform float qt_Opacity;
            uniform float width;
            uniform float height;
            uniform float offsetX;
            uniform float offsetY;
            uniform float scale;

            void main() {
                vec2 p = ((qt_TexCoord0 - 0.5) * vec2(width, height) - vec2(offsetX, offsetY)) * scale;
                vec2 z = p;
                int i;
                int count = 256;
                for (i = 0; i < count; ++i) {
                    vec2 z2;
                    z2.x = z.x * z.x - z.y * z.y;
                    z2.y = 2.0 * z.x * z.y;
                    z2 += p;
                    if (length(z2) > 4.0) break;
                    z = z2;
                }
                
                float value = (i == count) ? 0.0 : float(i) / float(count);
                gl_FragColor = vec4(value, value, sqrt(value), 1.0);
            }"
    }
    
    MouseArea {
        anchors.fill: parent
        
        property int prevX
        property int prevY
        property int scaleLevel: 0
        
        onPressed: {
            prevX = mouseX
            prevY = mouseY
        }
        
        onPositionChanged: {
            
            if (pressedButtons == Qt.LeftButton) {
                var dx = mouseX - prevX
                var dy = mouseY - prevY
                mandelbrot.offsetX = mandelbrot.offsetX + dx
                mandelbrot.offsetY = mandelbrot.offsetY + dy
            }
            
            prevX = mouseX
            prevY = mouseY
        }
        
        onWheel: {
            scaleLevel = scaleLevel + wheel.pixelDelta.y
            var levelFactor = 0.01;
            mandelbrot.scale = mandelbrot.scaleOrigin * Math.pow(2.0, scaleLevel * levelFactor);
            mandelbrot.offsetX = mandelbrot.offsetX * Math.pow(2.0, -wheel.pixelDelta.y * levelFactor)
            mandelbrot.offsetY = mandelbrot.offsetY * Math.pow(2.0, -wheel.pixelDelta.y * levelFactor)
        }
    }
}
