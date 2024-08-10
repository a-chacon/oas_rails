# Changelog

## [0.4.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.3.0...oas_rails/v0.4.0) (2024-08-10)


### Features

* add default responses configuration (errors). ([e4b3666](https://github.com/a-chacon/oas_rails/commit/e4b36665a2902bd73a447f762bb6aa007db925db))


### Code Refactoring

* move OAS creation logic to builders and replace common objects ([64d7922](https://github.com/a-chacon/oas_rails/commit/64d792256ef9c7a46e54e901ca3bb74cd2ed1f8a))
* organize OAS models into Spec module. ([#13](https://github.com/a-chacon/oas_rails/issues/13)) ([71a1515](https://github.com/a-chacon/oas_rails/commit/71a15150fb093a6402cfed26f4605cba9facd479))

## [0.3.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.2.3...oas_rails/v0.3.0) (2024-08-02)


### Features

* **media_type:** generate examples with factory bot if it is available and a factory is defined for detected class. ([4c904a8](https://github.com/a-chacon/oas_rails/commit/4c904a878dc3ae168c256821db9e14446fe26c2c))


### Bug Fixes

* **media_type:** models and examples identify by default was equal. But in the practice there are some fields that are different ex: created_at is sended in a response but not in a create/update operation. ([56a7b4c](https://github.com/a-chacon/oas_rails/commit/56a7b4c08bb8f7ac6680de607ddf66fc0437219f))
* **route_extractor:** rubocop offense route_extractor.rb:84:11: C: Style/MultilineBlockChain: Avoid multi-line chains of blocks. ([cd8af2e](https://github.com/a-chacon/oas_rails/commit/cd8af2ebf3c79769beb744639ee2f7a491f881f7))


### Documentation

* **readme:** cover from my website ([aa7f4aa](https://github.com/a-chacon/oas_rails/commit/aa7f4aa1f9f5de05ba05abc66734291aa06364e0))
* **readme:** update example image ([59f43b3](https://github.com/a-chacon/oas_rails/commit/59f43b387448b3ce18b4a1bc507612e69ddd3a4a))


### Code Refactoring

* **route_extractor:** move the RouteExtrator class into de Extractors module. ([d06cf8a](https://github.com/a-chacon/oas_rails/commit/d06cf8a482732b58795079f827d3b6f91a5f4e4b))

## [0.2.3](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.2.2...oas_rails/v0.2.3) (2024-08-01)


### Bug Fixes

* **specification:** clear_cache is an instance method, not class method. ([7a30667](https://github.com/a-chacon/oas_rails/commit/7a30667b73ace8fd6692b31d670ccba15b274700))
* **specification:** Make the reload works. ([be86263](https://github.com/a-chacon/oas_rails/commit/be8626391e24c0ff51fec1abd5dcdab14d1a3335))

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
