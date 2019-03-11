package;

import headbutt.twod.Headbutt;
import haxe.ds.Vector;
import haxe.Timer;
import glm.Vec2;
import differ.Collision;

class Benchmark {
    var results: Vector<Float>;
    public var mean(get, never): Float;
    public var std(get, never): Float;

    public function new(count: Int = 100) {
        results = new Vector(count);
    }

    static function bench(f: Void->Void, times: Int): Float {
        var start: Float = Timer.stamp();
        for(i in 0...times) f();
        var end: Float = Timer.stamp();

        return (end - start) / times;
    }

    public function run(f: Void->Void, times: Int = 1000) {
        for(i in 0...results.length) {
            results[i] = bench(f, times);
        }
    }

    function get_mean(): Float {
        var sum: Float = 0;
        for(result in results) {
            sum += result;
        }
        return sum / results.length;
    }

    function get_std(): Float {
        var mean: Float = this.mean;
        var sum: Float = 0;
        for(result in results) {
            sum += (result - mean) * (result - mean);
        }
        return Math.sqrt(sum / results.length);
    }

    static function disp_micro(x: Float): String {
        x = Math.fround(x * 10000000) / 10.0;
        return Std.string(x);
    }

    public function toString(): String {
        return '${disp_micro(mean)} ± ${disp_micro(std)}';
    }
}

class Main {
    public static function main(): Void {
        var hb: Headbutt = new Headbutt();
        Sys.println('| Test | Intersect | Headbutt (μs/iter) | Differ (μs/iter) |');
        Sys.println('|:-----|:---------:|---------:|-------:|');

        var lineA = new headbutt.twod.shapes.Line(new Vec2(-1, -1), new Vec2(1, 1));
        var lineB = new headbutt.twod.shapes.Line(new Vec2(-1, 1), new Vec2(1, -1));
        var lineC = new headbutt.twod.shapes.Line(new Vec2(1, -1), new Vec2(2, 1));
        var rayA = new differ.shapes.Ray(new differ.math.Vector(-1, -1), new differ.math.Vector(1,  1));
        var rayB = new differ.shapes.Ray(new differ.math.Vector(-1,  1), new differ.math.Vector(1, -1));
        var rayC = new differ.shapes.Ray(new differ.math.Vector(1, -1), new differ.math.Vector(2, 1));

        var line_line_int_hb = new Benchmark();
        line_line_int_hb.run(function() {
            hb.test(lineA, lineB);
        });
        var line_line_int_diff = new Benchmark();
        line_line_int_diff.run(function() {
            Collision.rayWithRay(rayA, rayB);
        });
        Sys.println('| line/line | ✔ | ${line_line_int_hb.toString()} | ${line_line_int_diff.toString()} |');

        var line_line_noint_hb = new Benchmark();
        line_line_noint_hb.run(function() {
            hb.test(lineA, lineC);
        });
        var line_line_noint_diff = new Benchmark();
        line_line_noint_diff.run(function() {
            Collision.rayWithRay(rayA, rayC);
        });
        Sys.println('| line/line | ✗ | ${line_line_noint_hb.toString()} | ${line_line_noint_diff.toString()} |');

        var circleA = new headbutt.twod.shapes.Circle(new Vec2(0, 0), 0.5);
        var circleB = new headbutt.twod.shapes.Circle(new Vec2(0.5, 0), 0.5);
        var circleC = new headbutt.twod.shapes.Circle(new Vec2(3, 0), 0.5);
        var dCircleA = new differ.shapes.Circle(0, 0, 0.5);
        var dCircleB = new differ.shapes.Circle(0.5, 0, 0.5);
        var dCircleC = new differ.shapes.Circle(3, 0, 0.5);

        var circ_circ_int_hb = new Benchmark();
        circ_circ_int_hb.run(function() {
            hb.test(circleA, circleB);
        });
        var circ_circ_int_diff = new Benchmark();
        circ_circ_int_diff.run(function() {
            Collision.shapeWithShape(dCircleA, dCircleB);
        });
        Sys.println('| circ/circ | ✔ | ${circ_circ_int_hb.toString()} | ${circ_circ_int_diff.toString()} |');

        var circ_circ_noint_hb = new Benchmark();
        circ_circ_noint_hb.run(function() {
            hb.test(circleA, circleC);
        });
        var circ_circ_noint_diff = new Benchmark();
        circ_circ_noint_diff.run(function() {
            Collision.shapeWithShape(dCircleA, dCircleC);
        });
        Sys.println('| circ/circ | ✗ | ${circ_circ_noint_hb.toString()} | ${circ_circ_noint_diff.toString()} |');

        var pentA = new headbutt.twod.shapes.Polygon([new Vec2(0, 1), new Vec2(1, 0.5), new Vec2(1, -1), new Vec2(-1, -1), new Vec2(-1, 0.5)]);
        var pentB = new headbutt.twod.shapes.Polygon([new Vec2(0, 1), new Vec2(1, 0.5), new Vec2(1, -1), new Vec2(-1, -1), new Vec2(-1, 0.5)]);
        pentB.set_trs(new Vec2(0.5, 0), 0, new Vec2(1, 1));
        var pentC = new headbutt.twod.shapes.Polygon([new Vec2(0, 1), new Vec2(1, 0.5), new Vec2(1, -1), new Vec2(-1, -1), new Vec2(-1, 0.5)]);
        pentC.set_trs(new Vec2(5, 0), 0, new Vec2(1, 1));
        var dpentA = new differ.shapes.Polygon(0, 0, [new differ.math.Vector(0, 1), new differ.math.Vector(1, 0.5), new differ.math.Vector(1, -1), new differ.math.Vector(-1, -1), new differ.math.Vector(-1, 0.5)]);
        var dpentB = new differ.shapes.Polygon(0.5, 0, [new differ.math.Vector(0, 1), new differ.math.Vector(1, 0.5), new differ.math.Vector(1, -1), new differ.math.Vector(-1, -1), new differ.math.Vector(-1, 0.5)]);
        var dpentC = new differ.shapes.Polygon(5, 0, [new differ.math.Vector(0, 1), new differ.math.Vector(1, 0.5), new differ.math.Vector(1, -1), new differ.math.Vector(-1, -1), new differ.math.Vector(-1, 0.5)]);

        var pent_pent_int_hb = new Benchmark();
        pent_pent_int_hb.run(function() {
            hb.test(pentA, pentB);
        });
        var pent_pent_int_diff = new Benchmark();
        pent_pent_int_diff.run(function() {
            Collision.shapeWithShape(dpentA, dpentB);
        });
        Sys.println('| pent/pent | ✔ | ${pent_pent_int_hb.toString()} | ${pent_pent_int_diff.toString()} |');

        var pent_pent_noint_hb = new Benchmark();
        pent_pent_noint_hb.run(function() {
            hb.test(pentA, pentC);
        });
        var pent_pent_noint_diff = new Benchmark();
        pent_pent_noint_diff.run(function() {
            Collision.shapeWithShape(dpentA, dpentC);
        });
        Sys.println('| pent/pent | ✗ | ${pent_pent_noint_hb.toString()} | ${pent_pent_noint_diff.toString()} |');
    }
}