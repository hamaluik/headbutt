import glm.Mat4;
import glm.Quat;
import headbutt.threed.shapes.Sphere;
import headbutt.threed.shapes.Polyhedron;
import headbutt.threed.shapes.Line;
import headbutt.threed.shapes.Box;
import buddy.*;
using buddy.Should;
import glm.Vec3;
import glm.Vec4;

@:access(headbutt.threed.Headbutt)
class TestShapes3D extends BuddySuite {
    public function new() {
        describe('Using A Polyhedron', {
            var p: Polyhedron;
            beforeEach({
                p = new Polyhedron([
                    new Vec3(-1, -1, -1),
                    new Vec3( 1, -1, -1),
                    new Vec3( 1, -1,  1),
                    new Vec3( 0,  1,  0),
                ]);
            });

            it('should calculate moved centres when transformed', {
                p.set_trs(new Vec3(0, 3, 4), Quat.identity(new Quat()), new Vec3(1, 1, 1));
                var c: Vec3 = p.centre;
                c.x.should.beCloseTo(0);
                c.y.should.beCloseTo(3);
                c.z.should.beCloseTo(4);
            });

            it('should calculate support vertices when untransformed', {
                var support: Vec3 = p.support(new Vec3(0, 1, 0));
                support.x.should.beCloseTo(0);
                support.y.should.beCloseTo(1);
                support.z.should.beCloseTo(0);

                var support: Vec3 = p.support(new Vec3(-0.5, 1, 1));
                support.x.should.beCloseTo(0);
                support.y.should.beCloseTo(1);
                support.z.should.beCloseTo(0);
            });

            it('should calculate support vertices when translated', {
                p.set_trs(new Vec3(0, 3, 0), Quat.identity(new Quat()), new Vec3(1, 1, 1));
                
                var support: Vec3 = p.support(new Vec3(0, 1, 0));
                support.x.should.beCloseTo(0);
                support.y.should.beCloseTo(4);
                support.z.should.beCloseTo(0);
            });

            it('should calculate support vertices when rotated', {
                p.set_trs(new Vec3(0, 0, 0), Quat.fromEuler(Math.PI, 0, 0, new Quat()), new Vec3(1, 1, 1));
                
                var support: Vec3 = p.support(new Vec3(0, -1, 0));
                support.x.should.beCloseTo(0);
                support.y.should.beCloseTo(-1);
                support.z.should.beCloseTo(0);
            });
        });

        describe('Using A Box', {
            var b: Box;
            beforeEach({
                b = new Box(new Vec3(0.5, 0.5, 0.5));
            });

            it('should calculate moved centres when transformed', {
                b.set_trs(new Vec3(0, 3, 4), Quat.identity(new Quat()), new Vec3(1, 1, 1));
                var c: Vec3 = b.centre;
                c.x.should.beCloseTo(0);
                c.y.should.beCloseTo(3);
                c.z.should.beCloseTo(4);
            });

            it('should calculate support vertices when untransformed', {
                var support: Vec3 = b.support(new Vec3(1, 1, 1));
                support.x.should.beCloseTo(0.5);
                support.y.should.beCloseTo(0.5);
                support.z.should.beCloseTo(0.5);
            });

            it('should calculate support vertices when translated', {
                b.set_trs(new Vec3(0, 3, 4), Quat.identity(new Quat()), new Vec3(1, 1, 1));
                
                var support: Vec3 = b.support(new Vec3(1, 1, 1));
                support.x.should.beCloseTo(0.5);
                support.y.should.beCloseTo(3.5);
                support.z.should.beCloseTo(4.5);
            });

            it('should calculate support vertices when rotated', {
                b.set_trs(new Vec3(0, 0, 0), Quat.fromEuler(Math.PI, 0, 0, new Quat()), new Vec3(1, 1, 1));
                
                var support: Vec3 = b.support(new Vec3(-1, -1, -1));
                support.x.should.beCloseTo(-0.5);
                support.y.should.beCloseTo(-0.5);
                support.z.should.beCloseTo(-0.5);
            });
        });

        describe('Using A Sphere', {
            var s: Sphere;
            beforeEach({
                s = new Sphere(new Vec3(0, 0, 0), 1);
            });

            it('should calculate moved centres when transformed', {
                s.position = new Vec3(4, 1, 3);
                var c: Vec3 = s.centre;
                c.x.should.beCloseTo(4);
                c.y.should.beCloseTo(1);
                c.z.should.beCloseTo(3);
            });

            it('should calculate support vertices when untransformed', {
                var support: Vec3 = s.support(new Vec3(1, 1, 0));
                support.x.should.beCloseTo(1 / Math.sqrt(2));
                support.y.should.beCloseTo(1 / Math.sqrt(2));
                support.z.should.beCloseTo(0);
            });

            it('should calculate support vertices when translated', {
                s.position.x = 3;
                
                var support: Vec3 = s.support(new Vec3(1, 1, 0));
                support.x.should.beCloseTo(1 / Math.sqrt(2) + 3);
                support.y.should.beCloseTo(1 / Math.sqrt(2));
                support.z.should.beCloseTo(0);
            });
        });
    }
}