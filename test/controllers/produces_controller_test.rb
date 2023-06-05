require "test_helper"

class ProducesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    sign_in users(:john)
    @produce = produces(:apple)
  end

  test "should get index" do
    get produces_url
    assert_response :success
  end

  test "should get new" do
    get new_produce_url
    assert_response :success
  end

  test "should create produce" do
    assert_difference("Produce.count") do
      post produces_url, params: { produce: { name: @produce.name } }
    end

    assert_redirected_to produce_url(Produce.last)

    # Don't create a link
    assert Produce.last.links.empty?
  end

  test "should create produce with picture" do
    picture = fixture_file_upload('test/fixtures/files/apple.jpg')
    params = {
      produce: {
        name: @produce.name,
        picture: picture
      }
    }
    assert_difference("Produce.count") do
      post produces_url, params: params
    end

    assert_redirected_to produce_url(Produce.last)
  end

  test "should create produce with wikipedia link" do
    params = {
      produce: {
        name: @produce.name,
        links_attributes: {
          0 => {
            from: :wikipedia,
            url: 'https://en.wikipedia.org/wiki/Apple'
            }
          }
        }
      }

    assert_difference("Produce.count") do
      post produces_url, params: params
    end

    assert_redirected_to produce_url(Produce.last)

    assert Produce.last.links.any?
  end

  test "should show produce" do
    get produce_url(@produce)
    assert_response :success
  end

  test "should get edit" do
    get edit_produce_url(@produce)
    assert_response :success
  end

  test "should change produce name" do
    new_name = 'New name'
    patch produce_url(@produce), params: { produce: { name: new_name } }
    @produce.reload
    assert_equal new_name, @produce.name
    assert_redirected_to produce_url(@produce)
  end

  test "should add an image to produce" do
    picture = fixture_file_upload('test/fixtures/files/apple.jpg')
    patch produce_url(@produce), params: { produce: { picture: picture } }
    @produce.reload
    assert @produce.picture.attached?
    assert_redirected_to produce_url(@produce)
  end

  test "should add a link to produce that doesn't have one" do
    carrot = produces(:no_link)
    assert_not carrot.links.any?

    params = {
      produce: {
        name: carrot.name,
        links_attributes: {
          0 => {
            from: :wikipedia,
            url: 'https://en.wikipedia.org/wiki/Carrot'
            }
          }
        }
      }
    assert_difference("carrot.links.count") do
      patch produce_url(carrot), params: params
    end

    assert_redirected_to produce_url(carrot)
  end

  test "should edit link to produce that already has one" do
    params = {
      produce: {
        name: @produce.name,
        links_attributes: {
          0 => {
            id: @produce.links.wikipedia.first.id,
            from: :wikipedia,
            url: 'https://en.wikipedia.org/wiki/Carrot'
            }
          }
        }
      }

    assert_not @produce.main_link.include?('Carrot')

    assert_no_difference("Link.count") do
      patch produce_url(@produce), params: params
    end
    @produce.reload

    assert @produce.main_link.include?('Carrot')
  end

  test "should destroy produce" do
    assert_difference("Produce.count", -1) do
      delete produce_url(@produce)
    end

    assert_redirected_to produces_url
  end
end
