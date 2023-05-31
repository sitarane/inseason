require "test_helper"

class LinkTest < ActiveSupport::TestCase
  setup do
    @produce = produces(:apple)
  end

  test 'good link is valid' do
    link = @produce.links.new(from: :wikipedia, url: 'https://en.wikipedia.org/wiki/Apple')
    assert link.valid?
  end
  
  test 'link alone is invalid' do
    link = Link.new(from: :wikipedia, url: 'https://en.wikipedia.org/wiki/Apple')
    assert_not link.valid?
  end

  test 'link with no url is invalid' do
    link = @produce.links.new(from: :wikipedia)
    assert_not link.valid?
  end

  test 'link with no provenance is invalid' do
    link = @produce.links.new(url: 'https://en.wikipedia.org/wiki/Apple')
    assert_not link.valid?
  end
end
