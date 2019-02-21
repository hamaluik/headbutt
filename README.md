# headbutt

[![GitHub license](https://img.shields.io/badge/license-Apache%202-blue.svg?style=flat-square)](https://raw.githubusercontent.com/hamaluik/headbutt/master/LICENSE)
[![Build Status](https://img.shields.io/travis/hamaluik/headbutt.svg?style=flat-square)](https://travis-ci.org/hamaluik/headbutt)

A GJK and EPA collision engine made with pure [Haxe](http://haxe.org/).

## Usage

Create either 2D shapes or 3D shapes by implementing the appropriate interface: `headbutt.twod.Shape` / `headbutt.threed.Shape`. Or use one of the pre-defined shapes given in `headbutt.twod.shapes` / `headbutt.threed.shapes`:

* 2D
    + `Circle`
    + `Line`
    + `Rectangle`
    + `Polygon`
* 3D
    + `Sphere`
    + `Line`
    + `Box`
    + `Polyhedron`

Then, instantiate an instance of the appropriate `Headbutt`:

```haxe
var hb2 = new headbutt.twod.Headbutt();
var hb3 = new headbutt.threed.Headbutt();
```

Next, check shapes for intersections:

```haxe
if(hb2.test(shapeA, shapeB)) { /*...*/ }
if(hb3.test(objectA, objectB)) { /*...*/ }
```

Alternatively, calculate intersections (**note:** intersection calculations haven't been implemented in 3D yet!):

```haxe
var penetration: Null<Vec2> = hb2.intersect(shapeA, shapeB);
```

## API

### 2D

```haxe
// headbutt.twod.Shape
interface Shape {
    public var origin(get, set): Vec2;
    public function support(direction: Vec2): Vec2;
}
```

```haxe
// headbutt.twod.Headbutt
class Headbutt {
    /**
       The maximum number of simplex evolution iterations before we accept the
       given simplex. For non-curvy shapes, this can be low. Curvy shapes potentially
       require higher numbers, but this can introduce significant slow-downs at
       the gain of not much accuracy.
    */
    public var maxIterations:Int = 20;

    /**
       Create a new Headbutt instance. Headbutt needs to be instantiated because
       internally it stores state. This may change in the future.
    */
    public function new();

    /**
       Given two convex shapes, test whether they overlap or not
    */
    public function test(a: Shape, b: Shape): Bool;

    /**
       Given two shapes, test whether they overlap or not. If they don't, returns
       `null`. If they do, calculates the penetration vector and returns it.
    */
    public function intersect(a: Shape, b: Shape): Null<Vec2>;
}
```

### 3D

```haxe
// headbutt.threed.Shape
interface Shape {
    public var origin(get, set): Vec2;
    public function support(direction: Vec2): Vec2;
}
```

```haxe
// headbutt.threed.Headbutt
class Headbutt {
    /**
       The maximum number of simplex evolution iterations before we accept the
       given simplex. For non-curvy shapes, this can be low. Curvy shapes potentially
       require higher numbers, but this can introduce significant slow-downs at
       the gain of not much accuracy.
    */
    public var maxIterations:Int = 20;

    /**
       Create a new Headbutt instance. Headbutt needs to be instantiated because
       internally it stores state. This may change in the future.
    */
    public function new();

    /**
       Given two convex shapes, test whether they overlap or not
    */
    public function test(a: Shape, b: Shape): Bool;
}
```