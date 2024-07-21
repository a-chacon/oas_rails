# Open API Specification On Rails

OasRails is a Rails engine for generating **automatic interactive documentation for your Rails APIs**. Basically, it generates an **OAS 3.1** document and displays it using **[SwaggerUI](https://github.com/swagger-api/swagger-ui)**.

**Related Projects**:

- [ApiPie](https://github.com/Apipie/apipie-rails) (Doesn't support OAS 3.1, requires learning a DSL, lacks a nice UI)
- [swagger_yard-rails](https://github.com/livingsocial/swagger_yard-rails) (Seems abandoned, but serves as inspiration)
- [Rswag](https://github.com/rswag/rswag) (Not automatic, depends on RSpec; default test suite now is Minitest)

### Motivation

After trying the fast-api framework in Python, I was deeply fascinated by its interactive documentation. When I returned to Ruby on Rails, I sought similar functionality but couldn't find it. Years ago, I posted a [question on Stack Overflow](https://stackoverflow.com/questions/71947018/is-there-a-way-to-generate-an-interactive-documentation-for-rails-apis) and found nothing. Now, with some free time while freelancing as an API developer, I decided to try building my own tool for it, and here we are.

**This is not yet a production-ready solution**. I am actively working on it, but you can try it out. If you like the idea, please consider contributing to its development.

The goal is to do the least amount of work to get a complete documentation. If you follow REST principles in Rails, I believe we can achieve that. You can complement the documentation with [Yard](https://yardoc.org/) tags.

## Installation

Add this line to your Rails application's Gemfile:

```ruby
gem "oas_rails"
```

Then execute:

```bash
bundle
```

And finally mount the engine in your `route.rb` file:

```ruby
mount OasRails::Engine => '/docs'
```

You will have very **basic documentation** based on your routes and the information that the engine can get automatically at `localhost:3000/docs`. Then, **we should complement it** with an initializer file and [Yard](https://yardoc.org/) tags on our controller methods.

## Usage

To be completed soon...

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

The gem is available as open source under the terms of the [GPL-3.0](https://www.gnu.org/licenses/gpl-3.0.en.html#license-text).
