import js.Browser;
import js.three.Scene;
import js.three.MeshLambertMaterial;
import js.three.BoxGeometry;
import js.three.Mesh;
import js.three.SphereGeometry;
import js.three.PointLight;
import js.three.AmbientLight;
import js.three.PerspectiveCamera;
import js.three.WebGLRenderer;

import headbutt.Headbutt3D;
import headbutt.shapes.Sphere;
import headbutt.shapes.Polygon3D;
import glm.Vec3;

class Main {
    public static function main() {
        var hb:Headbutt3D = new Headbutt3D();
        
        // rendering stuff...
        var canvas:js.html.CanvasElement = cast(js.Browser.document.getElementById('canvas'));

		var scene:Scene = new Scene();
		
        var cubeMat:MeshLambertMaterial = new MeshLambertMaterial({ color: 0xcc0000 });
		var cube:Mesh = new Mesh(new BoxGeometry(50, 50, 50, 1, 1, 1), cubeMat);
		cube.position.set(0, 0, 0);
		scene.add(cube);

        var cubeShape:Polygon3D = new Polygon3D([
            new Vec3(-25, -25, -25), new Vec3(-25, -25,  25),
            new Vec3(-25,  25, -25), new Vec3(-25,  25,  25),
            new Vec3( 25, -25, -25), new Vec3( 25, -25,  25),
            new Vec3( 25,  25, -25), new Vec3( 25,  25,  25)
        ]);

        var sphere:Mesh = new Mesh(new SphereGeometry(20), new MeshLambertMaterial({color: 0x0000cc}));
        sphere.position.set(50, 0, 0);
        scene.add(sphere);

        var sphereShape:Sphere = new Sphere(new Vec3(50, 0, 0), 20);
		
		var pointLight = new PointLight(0xffffff, 1, 0);
		pointLight.position.set(100, 200, 50);
		scene.add(pointLight);

        var ambientLight = new AmbientLight(0x404040);
        scene.add(ambientLight);
		
		var camera = new PerspectiveCamera(70, canvas.clientWidth / canvas.clientHeight, 1, 1000);
        camera.position.set(75 * Math.cos(Math.PI/4), 75, 75 * Math.sin(Math.PI / 4));
        camera.lookAt(cube.position);
		scene.add(camera);
		
		var renderer = new WebGLRenderer({ canvas: canvas });
		renderer.setSize(js.Browser.document.body.clientWidth, js.Browser.document.body.clientHeight);
        renderer.setClearColor(0xffffff);
		
		Browser.document.body.appendChild(renderer.domElement);
        
        var t:Float = 0;
        var speed:Float = 0.1;
		
		var update = null;
		update = function(f:Float):Bool {
			Browser.window.requestAnimationFrame(update);
            camera.aspect = js.Browser.document.body.clientWidth / js.Browser.document.body.clientHeight;
	        renderer.setSize(js.Browser.document.body.clientWidth, js.Browser.document.body.clientHeight);
            camera.updateProjectionMatrix();

            sphere.position.x = 50 * Math.sin(2 * Math.PI * t * speed);
            sphere.position.y = 50 * Math.sin(2 * Math.PI * 2 * t * speed);
            sphere.position.z = 50 * Math.sin(2 * Math.PI * 4 * t * speed);

            sphereShape.centre.x = sphere.position.x;
            sphereShape.centre.y = sphere.position.y;
            sphereShape.centre.z = sphere.position.z;

            var collision:Bool = hb.test(cubeShape, sphereShape);
            cubeMat.setValues({
                color: collision ? 0x00cc00 : 0xcc0000
            });

			renderer.render(scene, camera);
            t += 1/60;
			return true;
		}
		update(0);
    }
}