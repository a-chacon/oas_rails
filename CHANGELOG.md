# Changelog

## [0.2.2](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.2.1...oas_rails/v0.2.2) (2024-07-31)


### Bug Fixes

* **media_types:** fixtures could be not present when looking for examples. It was raising an Errno::ENOENT. Now will be rescue and returned a default {}. ([03ff14d](https://github.com/a-chacon/oas_rails/commit/03ff14de0ad60751f01a94efcd7097d982821001))

## [0.2.1](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.2.0...oas_rails/v0.2.1) (2024-07-31)


### Bug Fixes

* **route_extractor:** Verify the correct implementation of a route. If ([e8ab706](https://github.com/a-chacon/oas_rails/commit/e8ab70668b32708f3c82ad69e7064da9adece5cf))

## [0.2.0](https://github.com/a-chacon/oas_rails/compare/oas_rails-v0.1.1...oas_rails/v0.2.0) (2024-07-30)


### Features

* add a configuration for filter routes. So if you have your api in the namespace /api/v1 you could add config.api_path='/api/v1' for filter the routes to be included in the documentation. ([22eaa9c](https://github.com/a-chacon/oas_rails/commit/22eaa9c1966e74230d5ff15566ecd07df40b9b7e))
* Add methods for documenting authorization. ([f543146](https://github.com/a-chacon/oas_rails/commit/f5431469ed5a4965ab536ae55a67503097fd0bfa))
* add release please workflow and release all changes ([1e137a4](https://github.com/a-chacon/oas_rails/commit/1e137a468a2b479aee32d9ff92ef18d08015aafc))
* add ruby version to repo ([0ac81a3](https://github.com/a-chacon/oas_rails/commit/0ac81a36c8d4cd0d45295e4c60270072752a393c))
* preparing first version of gem ([849922a](https://github.com/a-chacon/oas_rails/commit/849922a02d40cf38f3a29cf6a802d964b5020b14))
* release version 0.1.0 ([ca16692](https://github.com/a-chacon/oas_rails/commit/ca16692fc61acb8366a635bcebe3d365244bef3c))
* release version 0.1.1 ([2c2c5c6](https://github.com/a-chacon/oas_rails/commit/2c2c5c623a7c9ef8b59f4429c03ef003091dcbf5))


### Bug Fixes

* `protect_from_forgery` should be called in `OasRails::ApplicationController` ([76af772](https://github.com/a-chacon/oas_rails/commit/76af77242153f5e4b1dfff22d24f0a0bef698597))
* `protect_from_forgery` should be configured with `with: :exception` ([11fd990](https://github.com/a-chacon/oas_rails/commit/11fd99090f8e3653843b6cbea72600c0e40e46e5))
* extract functions from OasRails module to Utils module for fix offense of lenght module ([f740dca](https://github.com/a-chacon/oas_rails/commit/f740dca528ee9214e12afc292a7b7d71a3b037b1))
* make the same route respond with the RapiDoc view or the json file ([7fe53f3](https://github.com/a-chacon/oas_rails/commit/7fe53f37739cc38faaf675d1a09234651f303b4f))
* release plase config names ([c54f35f](https://github.com/a-chacon/oas_rails/commit/c54f35fa55895490643a056e7ce2cf1504e4f0ac))
* remove unused style import ([291efdf](https://github.com/a-chacon/oas_rails/commit/291efdf8dd8bb793690fe02f3dc94d15049a1729))
* rename configuration request_body_automatically to autodiscover_request_body ([266828e](https://github.com/a-chacon/oas_rails/commit/266828ee2c4257298ad8e942096062da3ae4f045))
* rubocop configuration and gemspec definition ([2b05b3d](https://github.com/a-chacon/oas_rails/commit/2b05b3df3f4e041bdbcc738505618a98bd45e678))
* set sqlite version in gemfile ([559d993](https://github.com/a-chacon/oas_rails/commit/559d99397c9ea8f20e3f7f3c37cd2e9e36e04329))
