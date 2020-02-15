import glm.Mat4;
import glm.Quat;
import headbutt.threed.Headbutt;
import headbutt.threed.shapes.Sphere;
import headbutt.threed.shapes.Polyhedron;
import headbutt.threed.shapes.Line;
import headbutt.threed.shapes.Box;
import buddy.*;
using buddy.Should;
import glm.Vec3;
import glm.Vec4;

@:access(headbutt.threed.Headbutt)
class TestHeadbutt3D extends BuddySuite {
    public function new() {
        describe('Using Headbutt 3D', {
            var hb:Headbutt;
            beforeEach({
                hb = new Headbutt();
            });

            it('should detect collisions for two polyhedrons which overlap', {
                var a:Polyhedron = new Polyhedron([
                    new Vec3(-1, -1, -1), new Vec3(-1, -1,  1),
                    new Vec3(-1,  1, -1), new Vec3(-1,  1,  1),
                    new Vec3( 1, -1, -1), new Vec3( 1, -1,  1),
                    new Vec3( 1,  1, -1), new Vec3( 1,  1,  1)
                ]);
                var b:Polyhedron = new Polyhedron([
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

            it('should calculate supports properly', {
                var a: Polyhedron = new Polyhedron([new Vec3(0, 0, 0)]);
                a.set_trs(new Vec3(1, 0, 0), Quat.identity(new Quat()), new Vec3(1, 1, 1));
                var m: Mat4 = a.transform;
                var vi: Vec4 = new Vec4(0, 0, 0, 1);
                var vo: Vec4 = Mat4.multVec(m, vi, new Vec4());

                vo.x.should.be(1);
                vo.y.should.be(0);
                vo.z.should.be(0);
                vo.w.should.be(1);

                var b:Polyhedron = new Polyhedron([
                    new Vec3(-1, -1, -1), new Vec3(-1, -1,  1),
                    new Vec3(-1,  1, -1), new Vec3(-1,  1,  1),
                    new Vec3( 1, -1, -1), new Vec3( 1, -1,  1),
                    new Vec3( 1,  1, -1), new Vec3( 1,  1,  1)
                ]);
                b.set_trs(new Vec3(5, 5, 5), Quat.identity(new Quat()), new Vec3(1, 1, 1));

                var o: Vec3 = b.support(new Vec3(1, 1, 1));
                o.x.should.be(6);
                o.x.should.be(6);
                o.x.should.be(6);

                var o: Vec3 = b.support(new Vec3(-1, -1, -1));
                o.x.should.be(4);
                o.x.should.be(4);
                o.x.should.be(4);

                var a:Polyhedron = new Polyhedron([
                    new Vec3(-1, -1, -1), new Vec3(-1, -1,  1),
                    new Vec3(-1,  1, -1), new Vec3(-1,  1,  1),
                    new Vec3( 1, -1, -1), new Vec3( 1, -1,  1),
                    new Vec3( 1,  1, -1), new Vec3( 1,  1,  1)
                ]);
                
                var o: Vec3 = a.support(new Vec3(1, 1, 1));
                o.x.should.be(1);
                o.x.should.be(1);
                o.x.should.be(1);
                
                var o: Vec3 = a.support(new Vec3(-1, -1, -1));
                o.x.should.be(-1);
                o.x.should.be(-1);
                o.x.should.be(-1);
            });

            it('should detect collisions for two polyhedrons which overlap', {
                var a:Polyhedron = new Polyhedron([
                    new Vec3(-1, -1, -1), new Vec3(-1, -1,  1),
                    new Vec3(-1,  1, -1), new Vec3(-1,  1,  1),
                    new Vec3( 1, -1, -1), new Vec3( 1, -1,  1),
                    new Vec3( 1,  1, -1), new Vec3( 1,  1,  1)
                ]);
                var b:Polyhedron = new Polyhedron([
                    new Vec3(-1, -1, -1), new Vec3(-1, -1,  1),
                    new Vec3(-1,  1, -1), new Vec3(-1,  1,  1),
                    new Vec3( 1, -1, -1), new Vec3( 1, -1,  1),
                    new Vec3( 1,  1, -1), new Vec3( 1,  1,  1)
                ]);

                var result:Bool = hb.test(a, b);
                result.should.be(true);
            });

            it('shouldn\'t detect collisions for two polyhedrons which don\'t overlap', {
                var a:Polyhedron = new Polyhedron([
                    new Vec3(-1, -1, -1),
                    new Vec3( 1, -1, -1),
                    new Vec3( 1, -1,  1),
                    new Vec3( 0,  1,  0),
                ]);
                var b:Polyhedron = new Polyhedron([
                    new Vec3(-1, -1, -1),
                    new Vec3( 1, -1, -1),
                    new Vec3( 1, -1,  1),
                    new Vec3( 0,  1,  0),
                ]);
                b.set_trs(new Vec3(5, 0, 0), Quat.identity(new Quat()), new Vec3(1, 1, 1));
                var result:Bool = hb.test(a, b);
                result.should.be(false);
            });

            it('should detect collisions for two spheres which overlap', {
                var sa:Sphere = new Sphere(new Vec3(0, 0, 0), 1);
                var sb:Sphere = new Sphere(new Vec3(1.75, 1.75, 1.75), 1);

                var result:Bool = hb.test(sa, sb);
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
                var p:Polyhedron = new Polyhedron([
                    new Vec3(-1, -1, -1), new Vec3(-1, -1,  1),
                    new Vec3(-1,  1, -1), new Vec3(-1,  1,  1),
                    new Vec3( 1, -1, -1), new Vec3( 1, -1,  1),
                    new Vec3( 1,  1, -1), new Vec3( 1,  1,  1)
                ]);
                var result:Bool = hb.test(s, p);
                result.should.be(true);
            });

            it('should detect collisions between a line and a sphere', {
                var line: Line = new Line(new Vec3(), new Vec3(5, 5, 5));
                var sphere: Sphere = new Sphere(new Vec3(3, 3, 3), 1);
                var result: Bool = hb.test(line, sphere);
                result.should.be(true);
            });

            it('should detect collisions between two boxes', {
                var boxA: Box = new Box(new Vec3(1, 1, 1));
                var boxB: Box = new Box(new Vec3(1, 1, 1));
                boxB.set_trs(new Vec3(0, 0.5, 0), Quat.identity(new Quat()), new Vec3(1, 1, 1));
                var result: Bool = hb.test(boxA, boxB);
                result.should.be(true);
            });

            it('should calculate the intersection of two spheres');
            it('should calculate the intersection of two polyhedrons');
            it('should calculate the intersection of a polygon and a sphere');
        });
    }
}