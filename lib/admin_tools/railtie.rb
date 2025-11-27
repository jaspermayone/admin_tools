# frozen_string_literal: true

module AdminTools
  class Railtie < ::Rails::Railtie
    initializer "admin_tools.helper" do
      ActiveSupport.on_load(:action_view) do
        include AdminTools::Helper
      end
    end
  end
end
