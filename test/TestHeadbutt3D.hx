import headbutt.Headbutt3D;
import headbutt.shapes.Sphere;
import headbutt.shapes.ConvexPolygon3D;
import buddy.*;
using buddy.Should;
import glm.Vec3;

@:access(headbutt.Headbutt3D)
class TestHeadbutt3D extends BuddySuite {
    public function new() {
        describe('Using Headbutt3D', {
            var hb:Headbutt3D;
            beforeEach({
                hb = new Headbutt3D();
            });

            it('should detect collisions for two polygons which overlap', {
                var a:ConvexPolygon3D = new ConvexPolygon3D(new Vec3(0, 0, 0), [
                    new Vec3(-1, -1, -1), new Vec3(-1, -1,  1),
                    new Vec3(-1,  1, -1), new Vec3(-1,  1,  1),
                    new Vec3( 1, -1, -1), new Vec3( 1, -1,  1),
                    new Vec3( 1,  1, -1), new Vec3( 1,  1,  1)
                ]);
                var b:ConvexPolygon3D = new ConvexPolygon3D(new Vec3(0, 0, 0), [
                    new Vec3(-0.5, -1, -1), new Vec3(-0.5, -1,  1),
                    new Vec3(-0.5,  1, -1), new Vec3(-0.5,  1,  1),
                    new Vec3( 0.5, -1, -1), new Vec3( 0.5, -1,  1),
                    new Vec3( 0.5,  1, -1), new Vec3( 0.5,  1,  1)
                ]);

                var result:Bool = hb.test(a, b);
                result.should.be(true);
            });

            it('should detect collisions for two spheres which overlap', {
                var sa:Sphere = new Sphere(new Vec3(0, 0, 0), 1);
                var sb:Sphere = new Sphere(new Vec3(0.5, 0.5, 0.5), 1);

                var result:Bool = hb.test(sa, sb);
                result.should.be(true);
            });

            it('shouldn\'t detect collisions for two polygons which don\'t overlap', {
                var a:ConvexPolygon3D = new ConvexPolygon3D(new Vec3(0, 0, 0), [
                    new Vec3(-1, -1, -1), new Vec3(-1, -1,  1),
                    new Vec3(-1,  1, -1), new Vec3(-1,  1,  1),
                    new Vec3( 1, -1, -1), new Vec3( 1, -1,  1),
                    new Vec3( 1,  1, -1), new Vec3( 1,  1,  1)
                ]);
                var b:ConvexPolygon3D = new ConvexPolygon3D(new Vec3(0, 0, 0), [
                    new Vec3(-5, -1, -1), new Vec3(-5, -1,  1),
                    new Vec3(-5,  1, -1), new Vec3(-5,  1,  1),
                    new Vec3(-4, -1, -1), new Vec3(-4, -1,  1),
                    new Vec3(-4,  1, -1), new Vec3(-4,  1,  1)
                ]);

                var result:Bool = hb.test(a, b);
                result.should.be(false);
            });

            it('shouldn\'t detect collisions for two spheres which don\'t overlap', {
                var sa:Sphere = new Sphere(new Vec3(0, 0, 0), 1);
                var sb:Sphere = new Sphere(new Vec3(2, 2, 2), 1);

                var result:Bool = hb.test(sa, sb);
                result.should.be(false);
            });

            it('should detect collisions between a shape and itself', {
                var s:Sphere = new Sphere(new Vec3(0, 0, 0), 1);
                var result:Bool = hb.test(s, s);
                result.should.be(true);
            });

            it('should detect collisions between a sphere and a polygon', {
                var s:Sphere = new Sphere(new Vec3(0.5, 0.5, 0.5), 1);
                var p:ConvexPolygon3D = new ConvexPolygon3D(new Vec3(0, 0, 0), [
                    new Vec3(-1, -1, -1), new Vec3(-1, -1,  1),
                    new Vec3(-1,  1, -1), new Vec3(-1,  1,  1),
                    new Vec3( 1, -1, -1), new Vec3( 1, -1,  1),
                    new Vec3( 1,  1, -1), new Vec3( 1,  1,  1)
                ]);
                var result:Bool = hb.test(s, p);
                result.should.be(true);
            });

            it('should calculate the intersection of two spheres');
            it('should calculate the intersection of two polygons');
            it('should calculate the intersection of a polygon and a sphere');
        });
    }
}