# Changelog

## [1.0.1](https://github.com/a-chacon/oas_rails/compare/oas_rails/v1.0.0...oas_rails/v1.0.1) (2025-06-25)


### Bug Fixes

* custom route extractor usage ([#147](https://github.com/a-chacon/oas_rails/issues/147)) ([99976a8](https://github.com/a-chacon/oas_rails/commit/99976a8a6ac92db10cad44cbac85d5eb2dcc1e2d))

## [1.0.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.17.1...oas_rails/v1.0.0) (2025-06-22)


### ⚠ BREAKING CHANGES

* implement source oas and bumping to oas_core 1.0.0 ([#143](https://github.com/a-chacon/oas_rails/issues/143))

### Features

* implement source oas and bumping to oas_core 1.0.0 ([#143](https://github.com/a-chacon/oas_rails/issues/143)) ([c02889b](https://github.com/a-chacon/oas_rails/commit/c02889b7d6fb948a6a69a5c5b438f987e230c507))

## [0.17.1](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.17.0...oas_rails/v0.17.1) (2025-06-14)


### Bug Fixes

* remove unused oas route variables ([a386b9e](https://github.com/a-chacon/oas_rails/commit/a386b9e35c37569616c93f61971d7ce168a98861))


### Documentation

* update screenshot of readme ([0fc582a](https://github.com/a-chacon/oas_rails/commit/0fc582a54afdab2cfd27608ba2e88538232a15b9))

## [0.17.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.16.0...oas_rails/v0.17.0) (2025-06-09)


### Features

* migrate to oas_core gem ([#136](https://github.com/a-chacon/oas_rails/issues/136)) ([5c38011](https://github.com/a-chacon/oas_rails/commit/5c3801110f77d38891bf644ec0ca9e0191195d83))

## [0.16.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.15.0...oas_rails/v0.16.0) (2025-06-06)


### Features

* Add support for file uploads ([#137](https://github.com/a-chacon/oas_rails/issues/137)) ([5c79a84](https://github.com/a-chacon/oas_rails/commit/5c79a8475f70b0eab69964067efc1b7824ada14d))

## [0.15.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.14.0...oas_rails/v0.15.0) (2025-05-28)


### Features

* add configurable route extractor to configuration ([#134](https://github.com/a-chacon/oas_rails/issues/134)) ([7e6d36c](https://github.com/a-chacon/oas_rails/commit/7e6d36cf8dd47095add4d5552be011214162444a))

## [0.14.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.13.0...oas_rails/v0.14.0) (2025-05-18)


### Features

* implement support for class level tags and refactors ([#121](https://github.com/a-chacon/oas_rails/issues/121)) ([6e19ef1](https://github.com/a-chacon/oas_rails/commit/6e19ef1a90e7b34522a1a0bdebff6baa9f7f2c36))


### Bug Fixes

* filter out rubocop and todo annotations ([#127](https://github.com/a-chacon/oas_rails/issues/127)) ([f46101c](https://github.com/a-chacon/oas_rails/commit/f46101c00429ffe0313e83901918dcb491f525b5))


### Documentation

* add demo app ([#118](https://github.com/a-chacon/oas_rails/issues/118)) ([101d233](https://github.com/a-chacon/oas_rails/commit/101d233b913b3c4fd3378d3f20bbf1e3e3a30e62))
* add star history ([4ac26ed](https://github.com/a-chacon/oas_rails/commit/4ac26ede932e9b2930c83af91ea1b65fb9e269b1))
* fix tags, it was just tag and that dont works with oas_rails ([#123](https://github.com/a-chacon/oas_rails/issues/123)) ([9c39510](https://github.com/a-chacon/oas_rails/commit/9c39510431a6f5f42d71d621c6ecffb15108da8b))
* update llms urls ([975a1ff](https://github.com/a-chacon/oas_rails/commit/975a1ffdf3e4eef84dd3c5d9de48d5530c23e590))


### Code Refactoring

* move logic from media type to example finder ([#114](https://github.com/a-chacon/oas_rails/issues/114)) ([8334b04](https://github.com/a-chacon/oas_rails/commit/8334b0431c16b40e42b9f817f5d0d1221f06f428))

## [0.13.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.12.0...oas_rails/v0.13.0) (2025-04-19)


### Features

* add support to active record classes in compound string structures ([#112](https://github.com/a-chacon/oas_rails/issues/112)) ([da0bba6](https://github.com/a-chacon/oas_rails/commit/da0bba6c8c2d822c1fff57968410c35752301831))


### Bug Fixes

* add validation to configuration default response body ([#108](https://github.com/a-chacon/oas_rails/issues/108)) ([7cd3cc4](https://github.com/a-chacon/oas_rails/commit/7cd3cc4bd9fac0406d41fd28f352c7a865a1eb50))
* update easy_tal to easy_talk_two fixing conversions of boolean and decimal fields ([#113](https://github.com/a-chacon/oas_rails/issues/113)) ([36cb39b](https://github.com/a-chacon/oas_rails/commit/36cb39bca1d377782da39439f92468d1d78fae04))

## [0.12.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.11.0...oas_rails/v0.12.0) (2025-04-12)


### Features

* add include_mode for handle what include in final oas ([#106](https://github.com/a-chacon/oas_rails/issues/106)) ([988b5d0](https://github.com/a-chacon/oas_rails/commit/988b5d04ce55639709481ea12f5c07c2fb127aea))
* order endpoints by tags in rapidoc. ([#105](https://github.com/a-chacon/oas_rails/issues/105)) ([f2bd784](https://github.com/a-chacon/oas_rails/commit/f2bd784aec4aa9252179e2b72ea00d7d0330ec55))


### Documentation

* make the book works in the root of the site ([312a0ca](https://github.com/a-chacon/oas_rails/commit/312a0ca7044679d118b17f39b5ea5bd6fa981470))

## [0.11.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.10.1...oas_rails/v0.11.0) (2025-04-07)


### Features

* add rapidoc assets to the gem. So will load locally without need CDN ([#94](https://github.com/a-chacon/oas_rails/issues/94)) ([ab0c684](https://github.com/a-chacon/oas_rails/commit/ab0c684e9b91cd5c2cf78b63fd13d8d29edda317))
* Ebook ([#98](https://github.com/a-chacon/oas_rails/issues/98)) ([e680d6b](https://github.com/a-chacon/oas_rails/commit/e680d6b8d9231162d6d9fbfbec600742bb89b27e))
* pre defined themes for rapidoc ([#96](https://github.com/a-chacon/oas_rails/issues/96)) ([6c5b75b](https://github.com/a-chacon/oas_rails/commit/6c5b75bbc40379242210f7bf59f6ec922b2706da))


### Bug Fixes

* finish to process a json schema from a active record class with easy talk ([#95](https://github.com/a-chacon/oas_rails/issues/95)) ([f3b4401](https://github.com/a-chacon/oas_rails/commit/f3b440195198b667db865435fb0701d9467a193e))
* small text fix in initializer template file ([#97](https://github.com/a-chacon/oas_rails/issues/97)) ([a31bfa0](https://github.com/a-chacon/oas_rails/commit/a31bfa063c285b98a35f33f173acf984e99e30cc))


### Documentation

* **readme:** add documentation for configure project's license ([#89](https://github.com/a-chacon/oas_rails/issues/89)) ([19fdb97](https://github.com/a-chacon/oas_rails/commit/19fdb972265099872cbb5e23f55b52947b2a5864))

## [0.10.1](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.10.0...oas_rails/v0.10.1) (2025-03-29)


### Bug Fixes

* include full web page structure in index views becouse the layout was not in use. ([2eec88a](https://github.com/a-chacon/oas_rails/commit/2eec88a88d67caa3680aae67b209644b7e347aea))
* **parameter builder:** return empty string when trying to extract word before path param ([c5fcb00](https://github.com/a-chacon/oas_rails/commit/c5fcb00cc85d5bacb234c612c7289f8acb747f9a))

## [0.10.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.9.0...oas_rails/v0.10.0) (2025-03-26)


### Features

* add support for multiline tag definition ([#83](https://github.com/a-chacon/oas_rails/issues/83)) ([4a7b3cf](https://github.com/a-chacon/oas_rails/commit/4a7b3cf3d29b6278843a4acaa79da418eddf6a72))
* set brackets to query params when they are defined as array. ([#79](https://github.com/a-chacon/oas_rails/issues/79)) ([6367528](https://github.com/a-chacon/oas_rails/commit/63675284d3359d3ef78d5678318e93c87bbc41f9))


### Bug Fixes

* error when fixture has erb ([#81](https://github.com/a-chacon/oas_rails/issues/81)) ([b42a637](https://github.com/a-chacon/oas_rails/commit/b42a63712c74e52d74fed67db7278447311a6ea8))


### Code Refactoring

* replace squema with easy_talk gem for convert active record classes to json squema ([#82](https://github.com/a-chacon/oas_rails/issues/82)) ([ced2f4f](https://github.com/a-chacon/oas_rails/commit/ced2f4f8adca791f0bce2cdf39cf6cb9ce8e0f72))

## [0.9.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.8.4...oas_rails/v0.9.0) (2025-01-29)


### Features

* Allow it to be used without ActiveRecord being present ([#72](https://github.com/a-chacon/oas_rails/issues/72)) ([340157d](https://github.com/a-chacon/oas_rails/commit/340157db4e3742a47d1c254dc218d0c4c93252cb))

## [0.8.4](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.8.3...oas_rails/v0.8.4) (2025-01-19)


### Bug Fixes

* block concurrent-ruby for rails 7 ([4a42e3c](https://github.com/a-chacon/oas_rails/commit/4a42e3c14ea2fe24d7f9d3f89b7502425492d7e2))
* Update with style tag to fix rapidoc button styling ([19e9ba1](https://github.com/a-chacon/oas_rails/commit/19e9ba137dd6063713233193d89ff655496b0ff1))

## [0.8.3](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.8.2...oas_rails/v0.8.3) (2024-12-21)


### Bug Fixes

* update dependencies and release changes not following conventional commits ([e97ea5b](https://github.com/a-chacon/oas_rails/commit/e97ea5b05716bd1d21956ad834a06af03246f105))

## [0.8.2](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.8.1...oas_rails/v0.8.2) (2024-10-11)


### Bug Fixes

* remove dependency of Rails 7 so it could run in Rails 8 too. ([#61](https://github.com/a-chacon/oas_rails/issues/61)) ([a57fd16](https://github.com/a-chacon/oas_rails/commit/a57fd1644406b63263538a38a503bc05e10bbe4f))

## [0.8.1](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.8.0...oas_rails/v0.8.1) (2024-10-01)


### Documentation

* **readme:** add demo video link ([48732e0](https://github.com/a-chacon/oas_rails/commit/48732e0d70789471d09596981e99c7bbfdc08eb5))
* **readme:** add some emojis and fix the indication for a required param ([2f0fca1](https://github.com/a-chacon/oas_rails/commit/2f0fca17f9668b0c77c8ff9bdc33911b0cc6ed0c))

## [0.8.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.7.0...oas_rails/v0.8.0) (2024-08-31)


### Features

* **route_extractor:** feature ignore custom route ([#54](https://github.com/a-chacon/oas_rails/issues/54)) ([e34b3ee](https://github.com/a-chacon/oas_rails/commit/e34b3ee4d0de3161f6af2cd890ffafc385701285))
* **view:** support custom layout ([#52](https://github.com/a-chacon/oas_rails/issues/52)) ([abef8d3](https://github.com/a-chacon/oas_rails/commit/abef8d3abe772514b71c49aaa298ef1fe0c8aa37))


### Bug Fixes

* **yard_oas_rails_factory:** set different expresion for request body examples ([ceea6eb](https://github.com/a-chacon/oas_rails/commit/ceea6eb3572006c2a0222f86625fc755d3c856db))


### Tests

* feature ignore custom route ([#55](https://github.com/a-chacon/oas_rails/issues/55)) ([aedbe7b](https://github.com/a-chacon/oas_rails/commit/aedbe7b610c3f5db5cadf8e59495351f8e83eddf))

## [0.7.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.6.0...oas_rails/v0.7.0) (2024-08-27)


### Features

* **view:** Adding the title from the config initializer in the views title ([#48](https://github.com/a-chacon/oas_rails/issues/48)) ([61cf843](https://github.com/a-chacon/oas_rails/commit/61cf84330fb66d0f400a9aa51ff3bfdd5cdde957))


### Documentation

* **readme:** Fix 'Hash' missing ([#49](https://github.com/a-chacon/oas_rails/issues/49)) ([aed623d](https://github.com/a-chacon/oas_rails/commit/aed623d5c28853ebbc2c021f96b3093b288fa4d2))

## [0.6.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.5.0...oas_rails/v0.6.0) (2024-08-26)


### Features

* add [@response](https://github.com/response)_example tag for document examples of responses. ([#43](https://github.com/a-chacon/oas_rails/issues/43)) ([16f37c4](https://github.com/a-chacon/oas_rails/commit/16f37c42a73ce6d3b29b80c9c643fea84253193a))


### Bug Fixes

* default body response following the new syntax ([a397555](https://github.com/a-chacon/oas_rails/commit/a3975556d3c4ba20a51636999e65c33944a8d3b7))

## [0.5.0](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.4.5...oas_rails/v0.5.0) (2024-08-23)


### Features

* disable autodiscover responses for endpoints with at least one documented response. ([ecd1318](https://github.com/a-chacon/oas_rails/commit/ecd13187a9f65d7b103095890a24bf7747268ca3))


### Code Refactoring

* redefine the way request body and responses are described. BREAKING.  ([ed5eef5](https://github.com/a-chacon/oas_rails/commit/ed5eef53bd10010b2c801a6b30a76084535ee27b))

## [0.4.5](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.4.4...oas_rails/v0.4.5) (2024-08-21)


### Bug Fixes

* return self when default responses and autodiscover is disabled. ([0d26fcc](https://github.com/a-chacon/oas_rails/commit/0d26fccf2cda3bcc2b0414fdef9dbcaaaccc4dbd))

## [0.4.4](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.4.3...oas_rails/v0.4.4) (2024-08-20)


### Bug Fixes

* make the test works with rake under 3.1 ([7220e26](https://github.com/a-chacon/oas_rails/commit/7220e26ad8579a7f08bd188c88c61fad230c1e20))
* manage when same route has two or more verbs ([cb99f31](https://github.com/a-chacon/oas_rails/commit/cb99f318cffd308fb4d78d1fc3286c63667a954a))
* use Rack::Utils.status_code instead of Rack::Utils::SYMBOL_TO_STATUS_CODE ([0c9dccb](https://github.com/a-chacon/oas_rails/commit/0c9dccba9da269580d69c6e5e9601bfbb4ee70f2))

## [0.4.3](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.4.2...oas_rails/v0.4.3) (2024-08-19)


### Bug Fixes

* rails version was ~&gt;7.0.0 which was not allowing to use 7.2 ([8e9e6e2](https://github.com/a-chacon/oas_rails/commit/8e9e6e2c8f140422e2d55ea581ecb5ed80c70791))

## [0.4.2](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.4.1...oas_rails/v0.4.2) (2024-08-15)


### Bug Fixes

* openapi document errors.  ([df4fb94](https://github.com/a-chacon/oas_rails/commit/df4fb94ede29dd37d2eaadbe63a49466af6244ee))


### Documentation

* **readme:** add badges for rails and ruby version ([9125108](https://github.com/a-chacon/oas_rails/commit/912510888a984b1d8f81c4ef0fe846d1b5f6f78c))


### Code Refactoring

* move json schema builder to builders module ([#21](https://github.com/a-chacon/oas_rails/issues/21)) ([8d32054](https://github.com/a-chacon/oas_rails/commit/8d320541cbe8e0fad9d3a1085ac5bf79f473b09f))

## [0.4.1](https://github.com/a-chacon/oas_rails/compare/oas_rails/v0.4.0...oas_rails/v0.4.1) (2024-08-11)


### Bug Fixes

* engine mounted path was not working on the index view. ([52e7936](https://github.com/a-chacon/oas_rails/commit/52e793645521ab7b8074092233f69a303d04e0bc))
* try to detect model class from all the namespaces of the controller ([d029862](https://github.com/a-chacon/oas_rails/commit/d0298622a39e61e12db06129de33235e5bfcb923))

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
