# AdminTools

A lightweight Rails gem for conditionally rendering admin-only content in views. Wrap any content in an `admin_tool` block and it only renders for admin users.

Inspired by [HCB's admin tools pattern](https://github.com/hackclub/hcb).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "admin_tools"
```

And then execute:

```bash
bundle install
rails generate admin_tools:install
```

## Usage

### Basic Usage

Use the `admin_tool` helper in your views to wrap content that should only be visible to admins:

```erb
<% admin_tool do %>
  <%= link_to "Edit", edit_admin_path(@resource) %>
  <%= button_to "Delete", @resource, method: :delete %>
<% end %>
```

Non-admin users see nothing. Admin users see the content wrapped in a `<div class="admin-tools">`.

### With CSS Classes

Pass additional CSS classes (great for Tailwind):

```erb
<% admin_tool("w-fit bg-red-50 p-2 rounded") do %>
  <p>Admin-only debugging info: <%= @resource.inspect %></p>
<% end %>
```

### Different Wrapper Element

Change the wrapper element type:

```erb
<% admin_tool("inline-flex gap-2", :span) do %>
  <span>Admin badge</span>
<% end %>
```

### With HTML Attributes

Pass additional HTML attributes:

```erb
<% admin_tool("", :div, data: { controller: "admin-panel" }, id: "admin-tools") do %>
  <%= render "admin/quick_actions" %>
<% end %>
```

### Conditional Admin Content

Use `admin_tool_if` when you want content visible to everyone OR just admins based on a condition:

```erb
<%# Show unpublish button only to admins when post is published %>
<% admin_tool_if(@post.published?) do %>
  <%= link_to "Unpublish", unpublish_path(@post) %>
<% end %>
```

When the condition is `false`, content shows to everyone. When `true`, only admins see it.

### Check Admin Visibility

You can also check visibility directly:

```erb
<% if admin_tools_visible? %>
  <p>You're an admin!</p>
<% end %>
```

## Configuration

Run the generator to create an initializer:

```bash
rails generate admin_tools:install
```

Then customize `config/initializers/admin_tools.rb`:

```ruby
AdminTools.configure do |config|
  # Method to call to get the current user (default: :current_user)
  config.current_user_method = :current_user

  # Method to call on the user to check if they're an admin (default: :admin?)
  config.admin_method = :admin?

  # CSS class applied to all admin_tool wrappers (default: "admin-tools")
  config.css_class = "admin-tools"

  # Default HTML element for wrapping content (default: :div)
  config.wrapper_element = :div
end
```

### Examples

**Using Devise with a `role` column:**

```ruby
config.current_user_method = :current_user
config.admin_method = :admin?  # assumes User#admin? exists
```

**Using a different auth system:**

```ruby
config.current_user_method = :authenticated_user
config.admin_method = :has_admin_role?
```

**Using Pundit or similar:**

```ruby
# In your ApplicationController
def admin_user?
  current_user&.admin? || policy(current_user).admin?
end
helper_method :admin_user?

# In initializer - call a helper method instead
config.admin_method = :itself  # Always returns truthy for non-nil users
# Then override admin_tools_visible? in ApplicationHelper:
#
# def admin_tools_visible?
#   admin_user?
# end
```

## Styling

Generate optional CSS to visually distinguish admin tools:

```bash
# Standard CSS
rails generate admin_tools:install --css

# Tailwind CSS
rails generate admin_tools:install --css --tailwind
```

This creates `app/assets/stylesheets/admin_tools.css` with a dashed red border and "Admin" label. Customize or remove in production as needed.

## Requirements

- Rails >= 6.1
- Ruby >= 3.0
- A `current_user` method (or configured equivalent) that returns the logged-in user
- An `admin?` method (or configured equivalent) on your User model

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests.

## Releasing

1. Update the version in `lib/admin_tools/version.rb`
2. Update `CHANGELOG.md`
3. Commit: `git commit -am "Release vX.X.X"`
4. Tag: `git tag vX.X.X`
5. Push: `git push origin main --tags`

The GitHub Action will automatically publish to RubyGems.org.

> **Note:** You need to configure [Trusted Publishing](https://guides.rubygems.org/trusted-publishing/) on RubyGems.org and create a `release` environment in your GitHub repo settings.

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
