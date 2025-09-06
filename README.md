![Gem Version](https://img.shields.io/gem/v/oas_rails?color=E9573F)
![GitHub License](https://img.shields.io/github/license/a-chacon/oas_rails?color=blue)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/a-chacon/oas_rails/.github%2Fworkflows%2Frubyonrails.yml)
![Gem Total Downloads](https://img.shields.io/gem/dt/oas_rails)
![Static Badge](https://img.shields.io/badge/Rails-%3E%3D7.0.0-%23E9573F)
![Static Badge](https://img.shields.io/badge/Ruby-%3E%3D3.1.0-%23E9573F)

# 📃Open API Specification For Rails

OasRails is a Rails engine for generating **automatic interactive documentation for your Rails APIs**. It generates an **OAS 3.1** document and displays it using **[RapiDoc](https://rapidocweb.com)**.

It relies on the [OasCore](https://github.com/a-chacon/oas_core) gem.

### 🚀 Demo App

Explore the interactive documentation live:

🔗 **[Open Demo App](https://paso.fly.dev/api/docs)**  
👤 **Username**: `oasrails`  
🔑 **Password**: `oasrails`

🎬 A Demo Installation/Usage Video:
<https://vimeo.com/1013687332>
🎬

![Screenshot](https://a-chacon.github.io/oas_core/assets/rails_theme.png)

## Related Projects

- **[ApiPie](https://github.com/Apipie/apipie-rails)**: Doesn't support OAS 3.1, requires learning a DSL, lacks a nice UI
- **[swagger_yard-rails](https://github.com/livingsocial/swagger_yard-rails)**: Seems abandoned, but serves as inspiration
- **[Rswag](https://github.com/rswag/rswag)**: Not automatic, depends on RSpec; Many developers now use Minitest as it's the default test framework
- **[grape-swagger](https://github.com/ruby-grape/grape-swagger)**: Requires Grape
- **[rspec_api_documentation](https://github.com/zipmark/rspec_api_documentation)**: Requires RSpec and a command to generate the docs

## What Sets OasRails Apart?

- **Dynamic**: No command required to generate docs
- **Simple**: Complement default documentation with a few comments; no need to learn a complex DSL
- **Pure Ruby on Rails APIs**: No additional frameworks needed (e.g., Grape, RSpec)

## 📽️ Motivation

After experiencing the interactive documentation in Python's fast-api framework, I sought similar functionality in Ruby on Rails. Unable to find a suitable solution, I [asked on Stack Overflow](https://stackoverflow.com/questions/71947018/is-there-a-way-to-generate-an-interactive-documentation-for-rails-apis) years ago. Now, with some free time while freelancing as an API developer, I decided to build my own tool.

**Note: This is not yet a production-ready solution. The code may be rough and behave unexpectedly, but I am actively working on improving it. If you like the idea, please consider contributing to its development.**

The goal is to minimize the effort required to create comprehensive documentation. By following REST principles in Rails, we believe this is achievable. You can enhance the documentation using [Yard](https://yardoc.org/) tags.

## Documentation

For see how to install, configure and use OasRails please refere to the [OasCore MDBook](https://a-chacon.github.io/oas_core)

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**. If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement". Don't forget to give the project a star⭐! Thanks again!

If you plan a big feature, first open an issue to discuss it before any development.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

OasRails is released under the [MIT License](https://opensource.org/licenses/MIT).

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=a-chacon/oas_rails&type=Date)](https://www.star-history.com/#a-chacon/oas_rails&Date)
