# @request_body_example

**Structure**: `@request_body_example text [type] structure`

Adds examples to the provided request body.

**One line example**:

`# @request_body_example A complete User. [Hash] {user: {name: 'Luis', age: 30, password: 'MyWeakPassword123'}}`

**Multi-line example**:

```ruby
  # @request_body_example basic user [Hash]
  #   {
  #     user: {
  #       name: "Oas",
  #       email: "oas@test.com",
  #       password: "Test12345"
  #     }
  #   }
```
