require 'opal-rspec'
require 'lissio'

##
# Spec helpers
module HTMLHelper
  # Add some html to the document for tests to use. Code is added then
  # removed before each example is run.
  #
  #     describe "some feature" do
  #       html "<div>bar</div>"
  #
  #       it "should have bar content" do
  #         # ...
  #       end
  #     end
  #
  # @param [String] html_string html content
  def self.html(html_string = "")
    html = %Q{<div id="vienna-spec-test-div">#{html_string}</div>}

    before do
      @_spec_html = Element.parse(html)
      @_spec_html.append_to_body
    end

    after do
      @_spec_html.remove
    end
  end
end

RSpec.configure do |config|
  config.extend HTMLHelper
end

