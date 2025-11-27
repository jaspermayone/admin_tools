# frozen_string_literal: true

module AdminTools
  module Helper
    # Renders content only for admin users
    #
    # @param class_name [String] Additional CSS classes to add to the wrapper
    # @param element [Symbol, String] HTML element to wrap content in (default: configured wrapper_element)
    # @param options [Hash] Additional HTML attributes for the wrapper element
    # @yield Block containing the content to render for admins
    #
    # @example Basic usage
    #   <% admin_tool do %>
    #     <%= link_to "Delete", resource_path, method: :delete %>
    #   <% end %>
    #
    # @example With CSS classes
    #   <% admin_tool("w-fit bg-red-50 p-2") do %>
    #     <p>Admin-only content</p>
    #   <% end %>
    #
    # @example With different wrapper element
    #   <% admin_tool("inline-flex", :span) do %>
    #     Admin badge
    #   <% end %>
    #
    # @example With HTML attributes
    #   <% admin_tool("", :div, data: { controller: "admin" }) do %>
    #     <%= render "admin/panel" %>
    #   <% end %>
    #
    def admin_tool(class_name = "", element = nil, **options, &block)
      return unless admin_tools_visible?

      element ||= AdminTools.configuration.wrapper_element
      css_classes = [AdminTools.configuration.css_class, class_name].reject(&:blank?).join(" ")

      concat content_tag(element, class: css_classes, **options, &block)
    end

    # Conditionally renders content for admins only based on a condition
    #
    # If condition is false, content is shown to ALL users.
    # If condition is true, content is only shown to admins.
    #
    # @param condition [Boolean] When true, restrict to admins only
    # @param args [Array] Arguments passed to admin_tool
    # @param options [Hash] Options passed to admin_tool
    # @yield Block containing the content
    #
    # @example Show draft badge to everyone, but admin actions only to admins
    #   <% admin_tool_if(@post.published?) do %>
    #     <%= link_to "Unpublish", unpublish_path(@post) %>
    #   <% end %>
    #
    def admin_tool_if(condition, *args, **options, &block)
      yield and return unless condition

      admin_tool(*args, **options, &block)
    end

    # Returns whether admin tools should be visible to the current user
    #
    # @return [Boolean]
    #
    def admin_tools_visible?
      user = send(AdminTools.configuration.current_user_method)
      return false if user.nil?

      user.send(AdminTools.configuration.admin_method)
    rescue NoMethodError
      false
    end
  end
end
