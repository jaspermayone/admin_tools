# frozen_string_literal: true

require "spec_helper"

RSpec.describe AdminTools::Configuration do
  subject(:config) { described_class.new }

  describe "defaults" do
    it "has default current_user_method" do
      expect(config.current_user_method).to eq(:current_user)
    end

    it "has default admin_method" do
      expect(config.admin_method).to eq(:admin?)
    end

    it "has default css_class" do
      expect(config.css_class).to eq("admin-tools")
    end

    it "has default wrapper_element" do
      expect(config.wrapper_element).to eq(:div)
    end
  end

  describe "custom configuration" do
    it "allows setting current_user_method" do
      config.current_user_method = :authenticated_user
      expect(config.current_user_method).to eq(:authenticated_user)
    end

    it "allows setting admin_method" do
      config.admin_method = :superuser?
      expect(config.admin_method).to eq(:superuser?)
    end

    it "allows setting css_class" do
      config.css_class = "my-admin-tools"
      expect(config.css_class).to eq("my-admin-tools")
    end

    it "allows setting wrapper_element" do
      config.wrapper_element = :span
      expect(config.wrapper_element).to eq(:span)
    end
  end
end

RSpec.describe AdminTools do
  describe ".configure" do
    it "yields the configuration" do
      described_class.configure do |config|
        config.admin_method = :is_admin?
      end

      expect(described_class.configuration.admin_method).to eq(:is_admin?)
    end
  end

  describe ".reset_configuration!" do
    it "resets to defaults" do
      described_class.configure do |config|
        config.admin_method = :custom_method
      end

      described_class.reset_configuration!

      expect(described_class.configuration.admin_method).to eq(:admin?)
    end
  end
end
