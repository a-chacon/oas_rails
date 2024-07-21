# Open API Specification On Rails

OasRails is a Rails engine for generate **automatic interactive documentation in your rails APIs**. Basically it generate an **OAS 3.1** document and then display it on **[SwaggerUI](https://github.com/swagger-api/swagger-ui)**.

**Related Projects**:

- [ApiPie](https://github.com/Apipie/apipie-rails) (Don't support OAS 3.1, You need to learn a DSL, Not nice UI)
- [swagger_yard-rails](https://github.com/livingsocial/swagger_yard-rails) (Seems to be abandoned, but this works like inspiration)
- [Rswag](https://github.com/rswag/rswag) (Not automatic, depend on Rspec and default test suit now is Minitest)

### Motivation

So, after giving a try to fast-api framework in python I was deeply facinating with his interactive documentation and came back to Ruby on Rails seeking the same but I cant find it. I write a [stackoverflow](https://stackoverflow.com/questions/71947018/is-there-a-way-to-generate-an-interactive-documentation-for-rails-apis) question years ago and found nothing. So now that I have time and was working as a freelancer developing an API I decided to try to build my own tool for do it and here we are.

**This is not a production ready solution**. I am working on it, but you can give a try and if you like the idea please think in contributing to build it.

The idea is to have do the less for have a complete documentation and if you follow the REST principles in Rails I think we can do it. Then you can complement the documentation with [Yard](https://yardoc.org/) tags.

## Usage

How to use my plugin.

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

You will have a very **basic documentation** based on your routes and the information that the engine can get automatically on `localhost:3000/docs`. Then **we should complement it** with an initializer file and [Yard](https://yardoc.org/) tags on ower controllers methods.

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
