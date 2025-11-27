# frozen_string_literal: true

require "spec_helper"
require "action_view"
require "action_view/helpers"

RSpec.describe AdminTools::Helper do
  let(:helper_class) do
    Class.new do
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper
      include ActionView::Helpers::OutputSafetyHelper
      include AdminTools::Helper

      attr_accessor :output_buffer, :current_user

      def initialize
        @output_buffer = ActionView::OutputBuffer.new
      end
    end
  end

  let(:admin_user) do
    double("User", admin?: true)
  end

  let(:regular_user) do
    double("User", admin?: false)
  end

  let(:helper) { helper_class.new }

  describe "#admin_tools_visible?" do
    context "when user is admin" do
      before { helper.current_user = admin_user }

      it "returns true" do
        expect(helper.admin_tools_visible?).to be true
      end
    end

    context "when user is not admin" do
      before { helper.current_user = regular_user }

      it "returns false" do
        expect(helper.admin_tools_visible?).to be false
      end
    end

    context "when no user is logged in" do
      before { helper.current_user = nil }

      it "returns false" do
        expect(helper.admin_tools_visible?).to be false
      end
    end

    context "with custom admin method" do
      let(:superuser) { double("User", superuser?: true) }

      before do
        AdminTools.configure { |c| c.admin_method = :superuser? }
        helper.current_user = superuser
      end

      it "uses the configured method" do
        expect(helper.admin_tools_visible?).to be true
      end
    end
  end

  describe "#admin_tool" do
    context "when user is admin" do
      before { helper.current_user = admin_user }

      it "renders content with default wrapper" do
        helper.admin_tool { helper.output_buffer << "Admin content" }

        expect(helper.output_buffer).to include('<div class="admin-tools">')
        expect(helper.output_buffer).to include("Admin content")
        expect(helper.output_buffer).to include("</div>")
      end

      it "adds custom classes" do
        helper.admin_tool("w-fit mt-2") { helper.output_buffer << "Content" }

        expect(helper.output_buffer).to include('class="admin-tools w-fit mt-2"')
      end

      it "uses custom element" do
        helper.admin_tool("", :span) { helper.output_buffer << "Content" }

        expect(helper.output_buffer).to include("<span")
        expect(helper.output_buffer).to include("</span>")
      end

      it "passes HTML options" do
        helper.admin_tool("", :div, id: "my-tools", data: { foo: "bar" }) do
          helper.output_buffer << "Content"
        end

        expect(helper.output_buffer).to include('id="my-tools"')
        expect(helper.output_buffer).to include('data-foo="bar"')
      end
    end

    context "when user is not admin" do
      before { helper.current_user = regular_user }

      it "renders nothing" do
        helper.admin_tool { helper.output_buffer << "Admin content" }

        expect(helper.output_buffer).to be_empty
      end
    end
  end

  describe "#admin_tool_if" do
    before { helper.current_user = admin_user }

    context "when condition is true" do
      it "only shows to admins" do
        helper.admin_tool_if(true) { helper.output_buffer << "Admin only" }

        expect(helper.output_buffer).to include("admin-tools")
        expect(helper.output_buffer).to include("Admin only")
      end

      it "hides from non-admins" do
        helper.current_user = regular_user
        helper.admin_tool_if(true) { helper.output_buffer << "Admin only" }

        expect(helper.output_buffer).to be_empty
      end
    end

    context "when condition is false" do
      it "shows to everyone" do
        helper.current_user = regular_user
        helper.admin_tool_if(false) { helper.output_buffer << "Everyone sees this" }

        expect(helper.output_buffer).to include("Everyone sees this")
        expect(helper.output_buffer).not_to include("admin-tools")
      end
    end
  end
end
