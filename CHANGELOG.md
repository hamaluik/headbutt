# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[Unreleased]: https://github.com/hamaluik/headbutt/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/hamaluik/headbutt/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/hamaluik/headbutt/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/hamaluik/headbutt/releases/tag/v0.3.0
