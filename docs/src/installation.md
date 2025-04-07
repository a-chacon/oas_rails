# Installation

1. Add this line to your Rails application's Gemfile:

   ```ruby
   gem "oas_rails"`
   ```

2. Execute:

   ```bash
   bundle
   ```

3. Mount the engine in your config/routes.rb file

   ```ruby
   mount OasRails::Engine => '/docs'
   ```

You'll now have **basic documentation** based on your routes and automatically gathered information at `localhost:3000/docs`. To enhance it, create an initializer file and add [Yard](https://yardoc.org/) tags to your controller methods.
