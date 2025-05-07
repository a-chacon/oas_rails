# @tags

**Structure**: `@tags Tag1,Tag2,Tag3`

Tags your endpoints. You can define these tags in the initializer file for documentation purposes, but it is not required to predefine them before use.

This tag accepts a string where tags are separated by commas (`,`). Each value becomes a tag for the documented endpoint.

**Examples**:

```ruby
# @tags Users
```

```ruby
# @tags Project, Admin
```
