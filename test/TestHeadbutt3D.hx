import headbutt.Headbutt3D;
import headbutt.shapes.Sphere;
import headbutt.shapes.Polygon3D;
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

            it('should calculate Minkowski difference supports with polygons', {
            });

            it('should detect collisions for two polygons which overlap', {
            });

            it('should detect collisions for two spheres which overlap', {
                var sa:Sphere = new Sphere(new Vec3(0, 0, 0), 1);
                var sb:Sphere = new Sphere(new Vec3(0.5, 0.5, 0.5), 1);

                var result:Bool = hb.test(sa, sb);
                result.should.be(true);
            });

            it('shouldn\'t detect collisions for two polygons which don\'t overlap', {
            });

            it('shouldn\'t detect collisions for two spheres which don\'t overlap', {
                var sa:Sphere = new Sphere(new Vec3(-1, -0.5, -0.5), 1);
                var sb:Sphere = new Sphere(new Vec3(0.5, 0.5, 0.5), 1);

                var result:Bool = hb.test(sa, sb);
                result.should.be(false);
            });

            it('shouldn\'t matter what order the polygons go in', {
            });

            it('should detect collisions between a shape and itself', {
            });

            it('should detect collisions between two lines', {
            });

            it('should detect collisions between a line and a polygon', {
            });

            it('should detect collisions between a line and a circle', {
            });

            it('should detect collisions between a polygon and a circle', {
            });

            it('should calculate the intersection of two boxes', {
            });

            it('should calculate the intersection of two circles', {
            });

            it('should calculate the intersection of a line and square', {
            });

            it('should calculate the intersection of two polygons', {
            });
        });
    }
}