import glm.Vec2;
import headbutt.twod.shapes.Circle;
import headbutt.twod.shapes.Polygon;
import headbutt.twod.Headbutt;
import js.Browser;
import js.html.CanvasElement;
import js.html.CanvasRenderingContext2D;

class Main {
    static var ctx:CanvasRenderingContext2D;

    static var hb:Headbutt;
    static var poly:Polygon;
    static var circ:Circle;
    static var mouseCirc:Circle;

    static var lastTime:Float = 0;
    static var circSpeed:Float = 30;
    static var circVelocity:Float;

    static var intersectingPoly:Bool = false;
    static var intersectingCirc:Bool = false;

    public static function main() {
        circVelocity = circSpeed;
        var canvas:CanvasElement = cast(Browser.document.getElementById('canvas'));
        canvas.width = canvas.clientWidth;
        canvas.height = canvas.clientHeight;
        ctx = canvas.getContext2d();
        Browser.window.requestAnimationFrame(draw);

        mouseCirc = new Circle(new Vec2(100, 100), 16);
        poly = new Polygon(new Vec2(0, 0), [new Vec2(10, 10), new Vec2(100, 25), new Vec2(50, 75)]);
        circ = new Circle(new Vec2(100, 150), 32);

        hb = new Headbutt();

        canvas.addEventListener('mousemove', onMouseMove);
        canvas.addEventListener('touchstart', onTouch);
        canvas.addEventListener('touchmove', onTouch);
    }

    static function onMouseMove(evt:js.html.MouseEvent):Void {
        moveCircle(evt.clientX, evt.clientY);
    }

    static function onTouch(evt:js.html.TouchEvent):Void {
        moveCircle(evt.touches[0].clientX, evt.touches[0].clientY);
        evt.stopPropagation();
    }

    static function moveCircle(x:Float, y:Float):Void {
        var rect:js.html.DOMRect = ctx.canvas.getBoundingClientRect();
        mouseCirc.origin.x = x - rect.left;
        mouseCirc.origin.y = y - rect.top;
    }

    static function draw(ts:Float) {
        var dt:Float = (ts - lastTime) / 1000;
        lastTime = ts;

        circ.origin.x += circVelocity * dt;
        if(circ.origin.x < circ.radius) {
            circ.origin.x = circ.radius;
            circVelocity = circSpeed;
        }
        else if(circ.origin.x > ctx.canvas.clientWidth - circ.radius) {
            circ.origin.x = ctx.canvas.clientWidth - circ.radius;
            circVelocity = -circSpeed;
        }

        intersectingPoly = hb.test(poly, mouseCirc);
        intersectingCirc = hb.test(circ, mouseCirc);

        ctx.canvas.width = ctx.canvas.clientWidth;
        ctx.canvas.height = ctx.canvas.clientHeight;
        ctx.clearRect(0, 0, ctx.canvas.clientWidth, ctx.canvas.clientHeight);

        ctx.beginPath();
        ctx.moveTo(poly.vertices[0].x, poly.vertices[0].y);
        for(i in 1...poly.vertices.length) {
            ctx.lineTo(poly.vertices[i].x, poly.vertices[i].y);
        }
        ctx.lineTo(poly.vertices[0].x, poly.vertices[0].y);
        ctx.strokeStyle = '#324D5C';
        ctx.lineWidth = 4;
        ctx.lineJoin = "round";
        ctx.lineCap = "round";
        ctx.stroke();

        ctx.beginPath();
        ctx.arc(circ.origin.x, circ.origin.y, circ.radius, 0, Math.PI * 2);
        ctx.stroke();

        ctx.beginPath();
        ctx.arc(mouseCirc.origin.x, mouseCirc.origin.y, mouseCirc.radius, 0, Math.PI * 2);
        ctx.fillStyle = (intersectingPoly || intersectingCirc) ? '#46B39D' : '#DE5B49';
        ctx.fill();

        Browser.window.requestAnimationFrame(draw);
    }
}