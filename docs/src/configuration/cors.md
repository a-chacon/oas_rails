# Enabling CORS for Interactive Documentation

By default, OasRails uses **RapiDoc** as the frontend for interactive API documentation. However, you can customize this to use other tools like Swagger UI or ReDoc if needed.

To test endpoints interactively using RapiDoc (or your chosen frontend), you must enable Cross-Origin Resource Sharing (CORS) in your Rails application. Follow these steps:

1. **Add the `rack-cors` gem** to your `Gemfile` (Or uncomment):

   ```ruby
   gem 'rack-cors'
   ```

2. **Run `bundle install`** to install the gem.

3. **Configure CORS** in `config/initializers/cors.rb` (create the file if it doesn't exist):

   ```ruby
   Rails.application.config.middleware.insert_before 0, Rack::Cors do
     allow do
       origins '*'  # For development, allow all origins. Restrict this in production.
       resource '*',
         headers: :any,
         methods: [:get, :post, :put, :patch, :delete, :options, :head],
         credentials: false  # Set to `true` if using cookies or authentication headers.
     end
   end
   ```

4. **Restart your Rails server** for the changes to take effect.

This will allow RapiDoc to make requests to your API endpoints from the browser.
