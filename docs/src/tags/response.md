# @response

**Structure**: `@response text(code) [type<structure>]`

Documents the responses of the endpoint and overrides the default responses found by the engine.

**One line example**:

`# @response User not found by the provided Id(404) [Hash{success: Boolean, message: String}]`

`# @response Validation errors(422) [Hash{success: Boolean, errors: Array<Hash{field: String, type: String, detail: Array<String>}>}]`

**Multi-line example**:

```ruby
  # @response A test response from an Issue(405)
  #   [
  #     Hash{
  #       message: String,
  #       data: Hash{
  #         availabilities: Array<String>,
  #         dates: Array<Date>
  #       }
  #     }
  #   ]
```
