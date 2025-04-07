# Customizing the View

The OasRails engine provides an easy way to display your OpenAPI Specification (OAS) within your Rails application. By default, it includes an `index` view in the `OasRailsController` that displays [RapiDoc](https://rapidocweb.com/) through a CDN with default configurations. You can easily override this view to replace RapiDoc entirely or configure it differently.

### Available configurations

#### Changing the UI Theme

You can customize the appearance of the OAS documentation UI by setting the `config.rapidoc_theme` option in the initializer file. The default theme is `"rails"`, but you can choose from the following predefined themes:

- **dark**: Dark background with light text.
- **light**: Light background with dark text.
- **night**: Dark theme with a blueish tint.
- **mud**: Dark theme with brownish tones.
- **coffee**: Dark theme with warm brown tones.
- **forest**: Dark theme with greenish tones.
- **olive**: Dark theme with olive tones.
- **outerspace**: Dark theme with a space-like feel.
- **ebony**: Dark theme with deep blue tones.
- **snow**: Light theme with a clean white background.
- **green**: Light theme with green accents.
- **blue**: Light theme with blue accents.
- **beige**: Light theme with a beige background.
- **graynav**: Light theme with a gray navigation bar.
- **purplenav**: Light theme with a purple navigation bar.
- **lightgraynav**: Light theme with a light gray navigation bar.
- **darkbluenav**: Light theme with a dark blue navigation bar.
- **rails**: Default theme with Rails-inspired colors (red accents).

#### How to Configure the Theme

To change the theme, add the following line to your `config/initializers/oas_rails.rb` file:

```ruby
OasRails.configure do |config|
  config.rapidoc_theme = "dark" # Replace "dark" with your preferred theme name
end
```

Any other modification will require that you overwrite the index view explained in the next steps.

### Overriding the `index` View

To override the `index` view provided by the OasRails engine, follow these steps:

1. **Create the Override View File**: In your host application, create a new file at the path `app/views/oas_rails/oas_rails/index.html.erb`. If the directories do not exist, you will need to create them.

2. **Customize the View**: Open the newly created `index.html.erb` file and add your custom HTML and ERB code to display the OAS as desired. You can refer to the source code of this project for guidance.

#### Using the Custom View

Once the custom view file is in place, Rails will automatically use it instead of the view provided by the OasRails engine. This allows you to fully customize the presentation of the OAS without modifying the engine's code.
