# frozen_string_literal: true

require "rails/generators/base"

module AdminTools
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      desc "Creates an AdminTools initializer and optional CSS file"

      class_option :css, type: :boolean, default: false, desc: "Generate CSS file with default styles"
      class_option :tailwind, type: :boolean, default: false, desc: "Use Tailwind CSS classes in generated CSS"

      def create_initializer
        template "initializer.rb", "config/initializers/admin_tools.rb"
      end

      def create_css_file
        return unless options[:css]

        if options[:tailwind]
          template "admin_tools_tailwind.css", "app/assets/stylesheets/admin_tools.css"
        else
          template "admin_tools.css", "app/assets/stylesheets/admin_tools.css"
        end
      end

      def show_readme
        readme "README" if behavior == :invoke
      end
    end
  end
end
