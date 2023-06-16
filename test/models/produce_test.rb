require "test_helper"

class ProduceTest < ActiveSupport::TestCase
  setup do
    @produce = produces(:apple)
  end

  test "can't create nameless" do
    produce = Produce.new
    assert_not produce.valid?
  end

  test 'cant create same name' do
    assert_not Produce.new(name: @produce.name).valid?
  end

  test 'can save without image' do
    produce = Produce.new(name: 'Banana')
    assert produce.save
  end

  test '#main_link returns nil when no link' do
    assert_nil produces(:no_link).main_link
  end

  test '#main_link returns a link when present' do
    link = produces(:apple).main_link
    assert_instance_of String, link
    assert_match "wikipedia", link
  end
end
