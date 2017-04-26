import headbutt.Headbutt2D;
import headbutt.shapes.Polygon2D;
import headbutt.shapes.Circle;
import buddy.*;
using buddy.Should;
import glm.Vec2;

@:access(headbutt.Headbutt2D)
class TestHeadbutt2D extends BuddySuite {
    public function new() {
        describe('Using Headbutt2D', {
            var hb:Headbutt2D;
            beforeEach({
                hb = new Headbutt2D();
            });

            it('should calculate Minkowski difference supports with polygons', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-18, -18), new Vec2(-10, -18),
                    new Vec2(-10, -13), new Vec2(-18, -13)
                ]);
                var shapeB:Polygon2D = new Polygon2D([
                    new Vec2(-14, -14), new Vec2(-5, -16), new Vec2(-12, -8)
                ]);

                hb.shapeA = shapeA;
                hb.shapeB = shapeB;

                var verts:Array<Vec2> = new Array<Vec2>();
                for(a in shapeA.vertices) {
                    for(b in shapeB.vertices) {
                        verts.push(new Vec2(a.x - b.x, a.y - b.y));
                    }
                }
                var md:Polygon2D = new Polygon2D(verts);
                
                var dirs:Array<Vec2> = [
                    new Vec2(-1, 1), new Vec2(0, 1), new Vec2(1, 1),
                    new Vec2(-1, 0), new Vec2(1, 0),
                    new Vec2(-1, -1), new Vec2(0, -1), new Vec2(1, -1)
                ];
                for(dir in dirs) {
                    var mdSupport:Vec2 = md.support(dir);
                    var support:Vec2 = hb.calculateSupport(dir);
                    support.x.should.be(mdSupport.x);
                    support.y.should.be(mdSupport.y);
                }
            });

            it('should detect collisions for two polygons which overlap', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-18, -18), new Vec2(-10, -18),
                    new Vec2(-10, -13), new Vec2(-18, -13)
                ]);
                var shapeB:Polygon2D = new Polygon2D([
                    new Vec2(-14, -14), new Vec2(-5, -16), new Vec2(-12, -8)
                ]);

                var result:Bool = hb.test(shapeA, shapeB);
                result.should.be(true);
            });

            it('shouldn\'t detect collisions for two polygons which don\'t overlap', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-18, -18), new Vec2(-10, -18),
                    new Vec2(-10, -13), new Vec2(-18, -13)
                ]);
                var shapeB:Polygon2D = new Polygon2D([
                    new Vec2(-9, -14), new Vec2(0, -16), new Vec2(-7, -8)
                ]);

                var result:Bool = hb.test(shapeA, shapeB);
                result.should.be(false);
            });

            it('shouldn\'t matter what order the polygons go in', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-18, -18), new Vec2(-10, -18),
                    new Vec2(-10, -13), new Vec2(-18, -13)
                ]);
                var shapeB:Polygon2D = new Polygon2D([
                    new Vec2(-14, -14), new Vec2(-5, -16), new Vec2(-12, -8)
                ]);

                var resultA:Bool = hb.test(shapeA, shapeB);
                var resultB:Bool = hb.test(shapeB, shapeA);
                resultA.should.be(true);
                resultB.should.be(true);
            });

            it('should detect collisions between a shape and itself', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-18, -18), new Vec2(-10, -18),
                    new Vec2(-10, -13), new Vec2(-18, -13)
                ]);
                var result:Bool = hb.test(shapeA, shapeA);
                result.should.be(true);
            });

            it('should detect collisions between two lines', {
                var lineA:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, 1)
                ]);
                var lineB:Polygon2D = new Polygon2D([
                    new Vec2(-1, 1), new Vec2(1, -1)
                ]);

                var result:Bool = hb.test(lineA, lineB);
                result.should.be(true);
            });

            it('should detect collisions between a line and a polygon', {
                var shapeA:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, -1),
                    new Vec2(1, 1), new Vec2(-1, 1)
                ]);
                var lineA:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, 1)
                ]);

                var result:Bool = hb.test(shapeA, lineA);
                result.should.be(true);
            });

            it('should detect collisions between a line and a circle', {
                var circ:Circle = new Circle(new Vec2(0, 0), 1);
                var lineA:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, 1)
                ]);
                var lineB:Polygon2D = new Polygon2D([
                    new Vec2(-5, -5), new Vec2(-5, 5)
                ]);

                var resultA:Bool = hb.test(circ, lineA);
                var resultB:Bool = hb.test(circ, lineB);

                resultA.should.be(true);
                resultB.should.be(false);
            });

            it('should detect collisions between a polygon and a circle', {
                var circ:Circle = new Circle(new Vec2(0.25, 0), 1);
                var square:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, -1),
                    new Vec2(1, 1), new Vec2(-1, 1)
                ]);

                var result:Bool = hb.test(circ, square);
                result.should.be(true);
            });

            it('should calculate the intersection of two boxes', {
                var squareA:Polygon2D = new Polygon2D([
                    new Vec2(-1, -1), new Vec2(1, -1),
                    new Vec2(1, 1), new Vec2(-1, 1)
                ]);
                var squareB:Polygon2D = new Polygon2D([
                    new Vec2(0.25, -1), new Vec2(2.75, -1),
                    new Vec2(2.75, 1), new Vec2(0.25, 1)
                ]);

                var result:Bool = hb.test(squareA, squareB);
                result.should.be(true);

                var intersection:Vec2 = hb.calculateIntersection();
                trace('intersection:');
                trace(intersection);
            });
        });
    }
}