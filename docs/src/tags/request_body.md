# @request_body

**Structure**: `@request_body text [type<structure>]`

Documents the request body needed by the endpoint. The structure is optional if you provide a valid Active Record class. Use `!` to indicate a required request body.

**One line example**:

`# @request_body The user to be created [!User]`

`# @request_body The user to be created [User]`

**Multi-line example**:

```ruby
  # @request_body User to be created
  #   [
  #     !Hash{
  #       user: Hash{
  #         name: String,
  #         email: String,
  #         age: Integer,
  #         cars: Array<
  #           Hash{
  #             identifier: String
  #           }
  #         >
  #       }
  #     }
  #   ]
```
