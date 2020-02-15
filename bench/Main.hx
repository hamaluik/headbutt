package;

import headbutt.twod.Headbutt;
import haxe.ds.Vector;
import haxe.Timer;
import glm.Vec2;

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
    static function println(s: String): Void {
        #if sys
        Sys.println(s);
        #elseif js
        js.html.Console.log(s);
        #else
        trace(s);
        #end
    }

    public static function main(): Void {
        var hb = new Headbutt();
        println('| Test | Intersect | Headbutt (μs/iter) |');
        println('|:-----|:---------:|---------:|-------:|');

        var lineA = new headbutt.twod.shapes.Line(new Vec2(-1, -1), new Vec2(1, 1));
        var lineB = new headbutt.twod.shapes.Line(new Vec2(-1, 1), new Vec2(1, -1));
        var lineC = new headbutt.twod.shapes.Line(new Vec2(1, -1), new Vec2(2, 1));

        var line_line_int_hb = new Benchmark();
        line_line_int_hb.run(function() {
            hb.test(lineA, lineB);
        });
        println('| line/line | ✔ | ${line_line_int_hb.toString()} |');

        var line_line_noint_hb = new Benchmark();
        line_line_noint_hb.run(function() {
            hb.test(lineA, lineC);
        });
        println('| line/line | ✗ | ${line_line_noint_hb.toString()} |');

        var circleA = new headbutt.twod.shapes.Circle(new Vec2(0, 0), 0.5);
        var circleB = new headbutt.twod.shapes.Circle(new Vec2(0.5, 0), 0.5);
        var circleC = new headbutt.twod.shapes.Circle(new Vec2(3, 0), 0.5);

        var circ_circ_int_hb = new Benchmark();
        circ_circ_int_hb.run(function() {
            hb.test(circleA, circleB);
        });
        println('| circ/circ | ✔ | ${circ_circ_int_hb.toString()} |');

        var circ_circ_noint_hb = new Benchmark();
        circ_circ_noint_hb.run(function() {
            hb.test(circleA, circleC);
        });
        println('| circ/circ | ✗ | ${circ_circ_noint_hb.toString()} |');

        var pentA = new headbutt.twod.shapes.Polygon([new Vec2(0, 1), new Vec2(1, 0.5), new Vec2(1, -1), new Vec2(-1, -1), new Vec2(-1, 0.5)]);
        var pentB = new headbutt.twod.shapes.Polygon([new Vec2(0, 1), new Vec2(1, 0.5), new Vec2(1, -1), new Vec2(-1, -1), new Vec2(-1, 0.5)]);
        pentB.set_trs(new Vec2(0.5, 0), 0, new Vec2(1, 1));
        var pentC = new headbutt.twod.shapes.Polygon([new Vec2(0, 1), new Vec2(1, 0.5), new Vec2(1, -1), new Vec2(-1, -1), new Vec2(-1, 0.5)]);
        pentC.set_trs(new Vec2(5, 0), 0, new Vec2(1, 1));

        var pent_pent_int_hb = new Benchmark();
        pent_pent_int_hb.run(function() {
            hb.test(pentA, pentB);
        });
        println('| pent/pent | ✔ | ${pent_pent_int_hb.toString()} |');

        var pent_pent_noint_hb = new Benchmark();
        pent_pent_noint_hb.run(function() {
            hb.test(pentA, pentC);
        });
        println('| pent/pent | ✗ | ${pent_pent_noint_hb.toString()} |');
    }
}