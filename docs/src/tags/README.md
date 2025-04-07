# Tags

In addition to the information provided in the initializer file and the data that can be extracted from the routes and methods automatically, it is essential to document your API in the following way. The documentation is created **with the help of YARD**, so the methods are documented with **comment tags**.

### Documenting Your Endpoints

Almost every tag description in an OAS file supports **markdown formatting** (e.g., bold, italics, lists, links) for better readability in the generated documentation. Additionally, **multi-line descriptions** are supported. When using multi-line descriptions, ensure the content is indented at least one space more than the tag itself to maintain proper formatting.

For example:

```ruby
  # @request_body_example Simple User [Hash]
  #   {
  #     user: {
  #       name: "Oas",
  #       email: "oas@test.com",
  #       password: "Test12345"
  #     }
  #   }
```

You can use these tags in your controller methods to enhance the automatically generated documentation. Remember to use markdown formatting in your descriptions for better readability in the generated OAS document.
