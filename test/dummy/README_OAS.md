This dummy app demonstrates mounting the OasRails engine multiple times with separate configurations.

Mount points (configured in `config/routes.rb`):

- `/api/docs` -> public configuration (configuration: 'public')
- `/internal/api/docs` -> internal configuration (configuration: 'internal')

How this experiment is set up:

- Two models were created: `Post` and `Comment` (comments belong to posts).
- Controllers with basic JSON endpoints:
  - `PostsController` (index, show, create, update, destroy) — tag: `Posts`
  - `CommentsController` (create, destroy) nested under posts — tag: `Comments`
  - `Admin::ReportsController` (index) returning counts and recent posts — tag: `Admin` (internal)
  - Existing controllers with tags: `Users` (`UsersController`), `Projects` (`ProjectsController`), `Typed` (`TypedController`), `Users::Avatar` (`Users::AvatarController`)
- Two OAS configurations are declared in `config/initializers/oas_rails.rb`

Quick usage examples (using `curl`):

- Create a post:
  curl -X POST -H "Content-Type: application/json" -d '{"post": {"title": "Hello","body": "World","published": true}}' http://localhost:3000/posts

- Create a comment on post 1:
  curl -X POST -H "Content-Type: application/json" -d '{"comment": {"body": "Nice post","user": "bob"}}' http://localhost:3000/posts/1/comments

- List posts:
  curl http://localhost:3000/posts

- Admin reports (internal):
  curl http://localhost:3000/admin/reports

- View public docs:
  http://localhost:3000/api/docs

- View internal docs:
  http://localhost:3000/internal/api/docs

Notes:
- The OasRails engine must support the `default: { configuration: 'name' }` mount option. The initializer sets up two named configurations (`:public` and `:internal`).
- Controller actions include YARD tags such as `@summary`, `@tags`, `@parameter`, `@request_body`, and `@response` that OasRails can use to enrich the generated OpenAPI document. Example tags used in this dummy app:
  - `Users` — user-related endpoints (login, create, update, delete)
  - `Projects` — project management
  - `Typed` — typed endpoints used for testing Sorbet integration
  - `Posts` — public posts API (added in this experiment)
  - `Comments` — nested comments for posts
  - `Admin` — internal admin/operational endpoints (only in internal config)

If you want, I can:
- Add component schema YARD comments to `Post` and `Comment` models so OasRails will generate component schemas for them.
- Add request specs to validate that each mount serves a different configuration.
- Extend tags and operation descriptions with examples and response schemas.
