# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.6.0] - 2020-02-15
### Added
- Added `TestResult` type which is returned from `test()` and can be checked directly
  for collisions or passed to `intersect()` to further calculate an intersection
- Added `IntersectResult` type which is returned from `intersect()` and can be used
  to calculate collision normals, separation distances, etc
- Added `Headbutt.testAndIntersect()` function which is a shortcut for testing and
  then calculating the intersection if a collision is found

### Changed
- Changed `Headbutt` interface from interacting with an object with internal state
  to static pure functions (i.e. call `Headbutt.test()` instead of `new Headbutt().test()`)

## [0.5.0] - 2020-02-15
### Added
- Added transformation support to all provided shape classes
- Added tests for most shapes (not lines)
- Added tests for transformed shape collision calculations
- Added API documentation to all public interfaces

### Changed
- Changed `Shape.origin` getter/setter to a single `Shape.centre` getter
- Changed shape contructors to align with using transforms instead of an initial offset

## [0.4.0] - 2019-02-21
### Added
- Added 3D shapes
- Added 2D shapes
- Added some API documentation

### Changed
- Split 2D and 3D into their own packages: `headbutt.twod` and `headbutt.threed`
- Changed `Shape.centre` to `Shape.origin`

## [0.3.0] - 2017-07-01
- Initial release

[Unreleased]: https://github.com/hamaluik/headbutt/compare/v0.6.0...HEAD
[0.6.0]: https://github.com/hamaluik/headbutt/compare/v0.4.0...v0.6.0
[0.5.0]: https://github.com/hamaluik/headbutt/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/hamaluik/headbutt/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/hamaluik/headbutt/releases/tag/v0.3.0
