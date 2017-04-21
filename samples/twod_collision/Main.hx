import glm.Vec2;
import headbutt.shapes.Circle;
import headbutt.shapes.Polygon2D;
import headbutt.twod.GJK2D;

class Main {
    public static function main() {
        var a:Circle = new Circle(new Vec2(0, 0), 0.5);
        var b:Polygon2D = new Polygon2D([
            new Vec2(0.25, 0.25), new Vec2(5, 5)
        ]);
        var c:Circle = new Circle(new Vec2(5, 10), 1);

        var gjk:GJK2D = new GJK2D();
        trace(gjk.test(a, b)); // true
        trace(gjk.test(a, c)); // false
    }
}