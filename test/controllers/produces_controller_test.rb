require "test_helper"
require 'minitest/autorun'

class ProducesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:john)
    sign_in @user
    @produce = produces(:apple)
    @carrot = produces(:carrot)
    @no_season = produces :no_link
  end

  test "should get index" do
    get produces_url
    assert_response :success
  end

  test "should get new" do
    get new_produce_url
    assert_response :success
  end

  test "should populate #new with wiki page data" do
    Wikipedia::Client.stub :new, fake_wiki_client do
      get new_produce_url, params: { name: 'fake thing'}
    end
    assert_response :success
    assert_select 'input#produce_name', value: 'Fake thing'
  end

  test "should create produce from input" do
    assert_difference("Produce.count") do
      Wikipedia::Client.stub :new, fake_wiki_client do
        post produces_url,
          params: { produce: { name: 'Potato', user_id: @user.id } }
      end
    end

    assert_redirected_to produce_url(Produce.last, locale: :en)

    # Don't create a link
    assert Produce.last.links.empty?
  end

  test "should create produce with picture" do
    picture = fixture_file_upload('test/fixtures/files/apple.jpg')
    params = {
      produce: {
        name: 'Potato',
        user_id: @user.id,
        picture: picture
      }
    }
    assert_difference("Produce.count") do
      Wikipedia::Client.stub :new, fake_wiki_client do
        post produces_url, params: params
      end
    end

    assert_redirected_to produce_url(Produce.last, locale: :en)
  end

  test "should create produce with wikipedia link" do
    params = {
      produce: {
        name: 'Potato',
        user_id: @user.id,
        links_attributes: {
          0 => {
            from: :wikipedia,
            url: 'https://en.wikipedia.org/wiki/Apple'
            }
          }
        }
      }

    assert_difference("Produce.count") do
      Wikipedia::Client.stub :new, fake_wiki_client do
        post produces_url, params: params
      end
    end

    assert_redirected_to produce_url(Produce.last, locale: :en)

    assert Produce.last.links.any?
  end

  test "should show produce" do
    get produce_url(@produce)
    assert_response :success
  end

  test 'produce action buttons visible' do
    get produce_url(@produce)
    assert_select 'h1', @produce.name
    assert_select 'div#produce-actions a'
  end

  test "should get edit" do
    get edit_produce_url(@produce)
    assert_response :success
  end

  test 'shouldnt get edit on non-own produce' do
    assert_raise Pundit::NotAuthorizedError do
      get edit_produce_url(@carrot)
    end
  end

  test "should change produce name" do
    new_name = 'New name'
    patch produce_url(@produce), params: { produce: { name: new_name } }
    @produce.reload
    assert_equal new_name, @produce.name
    assert_redirected_to produce_url(@produce, locale: :en)
  end

  test "should add an image to produce" do
    picture = fixture_file_upload('test/fixtures/files/apple.jpg')
    patch produce_url(@produce), params: { produce: { picture: picture } }
    @produce.reload
    assert @produce.picture.attached?
    assert_redirected_to produce_url(@produce, locale: :en)
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

  test 'shouldnt destroy non-own produce' do
    assert_no_difference("Produce.count") do
      assert_raise Pundit::NotAuthorizedError do
        delete produce_url(@carrot)
      end
    end
  end

  test "shouldn't destroy produce with seasons" do
    assert_no_difference("Produce.count") do
      assert_raise Pundit::NotAuthorizedError do
        delete produce_url(@produce)
      end
    end
  end

  test "should destroy produce" do
    assert_difference("Produce.count", -1) do
      delete produce_url(@no_season)
    end

    assert_redirected_to produces_url(locale: :en)
  end
end
