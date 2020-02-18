# headbutt

[![GitHub license](https://img.shields.io/badge/license-Apache%202-blue.svg?style=flat-square)](https://raw.githubusercontent.com/hamaluik/headbutt/master/LICENSE)
[![Build Status](https://img.shields.io/travis/hamaluik/headbutt.svg?style=flat-square)](https://travis-ci.org/hamaluik/headbutt)

A GJK and EPA collision engine made with pure [Haxe](http://haxe.org/).

## Usage

Create either 2D shapes or 3D shapes by implementing the appropriate interface: `headbutt.twod.Shape` / `headbutt.threed.Shape`. Or use one of the pre-defined shapes given in `headbutt.twod.shapes` / `headbutt.threed.shapes`:

* 2D
  * `Circle`
  * `Line`
  * `Rectangle`
  * `Polygon`
* 3D
  * `Sphere`
  * `Line`
  * `Box`
  * `Polyhedron`

Apply generic transformations to shapes:

```haxe
var box = new Box(new Vec3(0.5, 0.5, 0.5));
box.transform = GLM.transform(
  new Vec3(5, -1, 3), // translation
  Quat.fromEuler(Math.PI / 4, 0, Math.PI / 3, new Quat()), // rotation
  new Vec3(2, 1, 4) // scale
);
```

Then, check shapes for intersections:

```haxe
if(headbutt.twod.Headbutt.test(shapeA, shapeB)) { /*...*/ }
if(headbutt.threed.Headbutt.test(objectA, objectB)) { /*...*/ }
```

Alternatively, calculate intersections (**note:** intersection calculations haven't been implemented in 3D yet!):

```haxe
var testResult = headbutt.twod.Headbutt.test(shapeA, shapeB);
var intersection = headbutt.twod.Headbutt.intersect(testResult);
// or:
var intersection = headbutt.twod.Headbutt.testAndIntersect(shapeA, shapeB);
```

## API

[API documentation is available.](https://hamaluik.github.com/headbutt/)

## Benchmarks

Benchmarks were run for the Node / Javascript target using `haxe bench.hxml`. The
benchmarks were collected on an Intel(R) Core(TM) i7-7700HQ CPU @ 2.80GHz with
16 GB of DDR4 RAM, running Linux Manjaro 19.0.0.

| Benchmark                              |         Mean Time / Iteration |
|:---------------------------------------|------------------------------:|
| 2D test line/line intersect            | `162.654 [ns] ±   2.982 [ns]` |
| 2D test line/line no intersect         | `126.105 [ns] ±   2.486 [ns]` |
| 2D test circle/circle intersect        | `246.520 [ns] ±   5.394 [ns]` |
| 2D test circle/circle no intersect     | ` 78.339 [ns] ±   1.650 [ns]` |
| 2D test pentagon/pentagon intersect    | `392.746 [ns] ±   2.768 [ns]` |
| 2D test pentagon/pentagon no intersect | `126.104 [ns] ±   1.947 [ns]` |
| 2D intersect line/line                 | `337.045 [ns] ±   2.785 [ns]` |
| 2D intersect circle/circle             | ` 11.901 [μs] ±  86.617 [ns]` |
| 2D intersect pentagon/pentagon         | `  1.916 [μs] ±   8.471 [ns]` |
| 3D test sphere/sphere intersect        | `201.095 [ns] ±   2.095 [ns]` |
| 3D test sphere/sphere no intersect     | ` 69.234 [ns] ±   1.347 [ns]` |
| 3D test box/box intersect              | `194.634 [ns] ±   1.847 [ns]` |
| 3D test box/box no intersect           | `983.447 [ns] ±   7.303 [ns]` |