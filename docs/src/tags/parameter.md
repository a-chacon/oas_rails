# @parameter

**Structure**: `@parameter name(position) [type] text`

Represents a parameter for the endpoint. The position can be: `header`, `path`, `cookie`, or `query`. The type should be a valid Ruby class: `String`, `Integer`, `Array<String>`, etc. Add a `!` before the class to indicate a required parameter.

**Examples**:
`# @parameter page(query) [Integer] The page number.`
`# @parameter slug(path) [!String] Slug of the Project.`
