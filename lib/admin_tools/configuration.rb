# frozen_string_literal: true

module AdminTools
  class Configuration
    attr_accessor :current_user_method, :admin_method, :css_class, :wrapper_element

    def initialize
      @current_user_method = :current_user
      @admin_method = :admin?
      @css_class = "admin-tools"
      @wrapper_element = :div
    end
  end
end
