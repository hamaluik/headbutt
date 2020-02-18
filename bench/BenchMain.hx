package;

import haxe.ds.Vector;
import haxe.Timer;
import glm.Vec2;
import glm.Vec3;
import benched.Benched;

class BenchMain {
    public static function main(): Void {
        var lineA = new headbutt.twod.shapes.Line(new Vec2(-1, -1), new Vec2(1, 1));
        var lineB = new headbutt.twod.shapes.Line(new Vec2(-1, 1), new Vec2(1, -1));
        var lineC = new headbutt.twod.shapes.Line(new Vec2(1, -1), new Vec2(2, 1));

        var circleA = new headbutt.twod.shapes.Circle(new Vec2(0, 0), 0.5);
        var circleB = new headbutt.twod.shapes.Circle(new Vec2(0.5, 0), 0.5);
        var circleC = new headbutt.twod.shapes.Circle(new Vec2(3, 0), 0.5);

        var pentagonA = new headbutt.twod.shapes.Polygon([
            new Vec2(0, 1),
            new Vec2(1, 0.5),
            new Vec2(1, -1),
            new Vec2(-1, -1),
            new Vec2(-1, 0.5),
        ]);
        var pentagonB = new headbutt.twod.shapes.Polygon([
            new Vec2(0, 1),
            new Vec2(1, 0.5),
            new Vec2(1, -1),
            new Vec2(-1, -1),
            new Vec2(-1, 0.5),
        ]);
        pentagonB.setTransform(new Vec2(0.5, 0), 0, new Vec2(1, 1));
        var pentagonC = new headbutt.twod.shapes.Polygon([
            new Vec2(0, 1),
            new Vec2(1, 0.5),
            new Vec2(1, -1),
            new Vec2(-1, -1),
            new Vec2(-1, 0.5),
        ]);
        pentagonC.setTransform(new Vec2(5, 0), 0, new Vec2(1, 1));

        var sphereA = new headbutt.threed.shapes.Sphere(new Vec3(0, 0, 0), 0.5);
        var sphereB = new headbutt.threed.shapes.Sphere(new Vec3(0, 0.5, 0), 0.5);
        var sphereC = new headbutt.threed.shapes.Sphere(new Vec3(0, 0, 3), 0.5);

        var boxA = new headbutt.threed.shapes.Box(new Vec3(0.5, 0.5, 0.5));
        var boxB = new headbutt.threed.shapes.Box(new Vec3(0.5, 0.5, 0.5));
        boxB.setTransform(new Vec3(0.5, 0, 0), glm.Quat.identity(new glm.Quat()), new Vec3(1, 1, 1));
        var boxC = new headbutt.threed.shapes.Box(new Vec3(0.5, 0.5, 0.5));
        boxB.setTransform(new Vec3(5, 5, 5), glm.Quat.identity(new glm.Quat()), new Vec3(1, 1, 1));

        var bencher = new Benched(1.0, 30);
        bencher.benchmark("2D test line/line intersect", () -> headbutt.twod.Headbutt.test(lineA, lineB));
        bencher.benchmark("2D test line/line no intersect", () -> headbutt.twod.Headbutt.test(lineA, lineC));
        bencher.benchmark("2D test circle/circle intersect", () -> headbutt.twod.Headbutt.test(circleA, circleB));
        bencher.benchmark("2D test circle/circle no intersect", () -> headbutt.twod.Headbutt.test(circleA, circleC));
        bencher.benchmark("2D test pentagon/pentagon intersect", () -> headbutt.twod.Headbutt.test(pentagonA, pentagonB));
        bencher.benchmark("2D test pentagon/pentagon no intersect", () -> headbutt.twod.Headbutt.test(pentagonA, pentagonC));
        bencher.benchmark("2D intersect line/line", () -> headbutt.twod.Headbutt.testAndIntersect(lineA, lineB));
        bencher.benchmark("2D intersect circle/circle", () -> headbutt.twod.Headbutt.testAndIntersect(circleA, circleB));
        bencher.benchmark("2D intersect pentagon/pentagon", () -> headbutt.twod.Headbutt.testAndIntersect(pentagonA, pentagonB));
        bencher.benchmark("3D test sphere/sphere intersect", () -> headbutt.threed.Headbutt.test(sphereA, sphereB));
        bencher.benchmark("3D test sphere/sphere no intersect", () -> headbutt.threed.Headbutt.test(sphereA, sphereC));
        bencher.benchmark("3D test box/box intersect", () -> headbutt.threed.Headbutt.test(boxA, boxB));
        bencher.benchmark("3D test box/box no intersect", () -> headbutt.threed.Headbutt.test(boxA, boxC));
        Sys.println(bencher.generateReport());
    }
}