ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

Capybara.server_host = "0.0.0.0"
Capybara.app_host = "http://#{ENV.fetch("HOSTNAME")}:#{Capybara.server_port}"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  Geocoder.configure(lookup: :test, ip_lookup: :test)
  Geocoder::Lookup::Test.set_default_stub(
    [
      {
        'coordinates'  => [40.7143528, -74.0059731],
        'address'      => 'New York, NY, USA',
        'state'        => 'New York',
        'state_code'   => 'NY',
        'country'      => 'United States',
        'country_code' => 'US',
        display_name: 'New York'
      }
    ]
  )

  def fake_wiki_client
    fake_wiki_page = MiniTest::Mock.new
    fake_wiki_page.expect :title, "Fake thing"
    fake_wiki_page.expect :fullurl, "https://en.wikipedia.org/wiki/Fake_thing"
    fake_wiki_page.expect :main_image_url,
      "https://upload.wikimedia.org/wikipedia/commons/f/f7/fake_image.jpg"
    fake_wiki_page.expect :langlinks,
      { 'en' => 'Fake thing', 'fr' => 'Faux truc' }
    fake_wiki_page.expect :langlinks,
        { 'en' => 'Fake thing', 'fr' => 'Faux truc' }

    client = MiniTest::Mock.new
    client.expect :find, fake_wiki_page, ['fake thing']
    client
  end
end
