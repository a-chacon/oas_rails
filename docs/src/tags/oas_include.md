# @oas_include

Use this tag to explicitly include endpoints in the final OpenAPI Specification (OAS) file **when `include_mode` is set to `:explicit`**. Only endpoints annotated with `@oas_include` will be included.

## Usage

Add the `@oas_include` tag as a comment above the endpoint you want to document. For example:

### Endpoint Not Included (Default Behavior)

```ruby
def update
end
```

### Endpoint Included (With `@oas_include`)

```ruby
# @oas_include
def index
end
```
