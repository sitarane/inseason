require "test_helper"

class LinkTest < ActiveSupport::TestCase
  setup do
    @produce = produces(:apple)
  end

  test 'good link is valid' do
    link = @produce.links.new(from: :wikipedia, url: 'https://en.wikipedia.org/wiki/Apple')
    assert link.valid?
  end

  test 'no lang link is valid' do
    link = @produce.links.new(from: :wikipedia, url: 'https://wikipedia.org/wiki/Apple')
    assert link.valid?
  end

  test 'http is fine' do
    link = @produce.links.new(from: :wikipedia, url: 'http://en.wikipedia.org/wiki/Apple')
    assert link.valid?
  end

  test 'string link invalid' do
    link = @produce.links.new(from: :wikipedia, url: 'hello world')
    assert_not link.valid?
  end

  test 'ftp link invalid' do
    link = @produce.links.new(from: :wikipedia, url: 'ftp://en.wikipedia.org/wiki/Apple')
    assert_not link.valid?
  end

  test 'just domain is invalid' do
    link = @produce.links.new(from: :wikipedia, url: 'wikipedia.org/wiki/Apple')
    assert_not link.valid?
  end

  test 'wrong domain is invalid' do
    link = @produce.links.new(from: :wikipedia, url: 'https://duckduckgo.com')
    assert_not link.valid?
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
