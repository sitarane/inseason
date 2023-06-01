require "test_helper"

class ProduceTest < ActiveSupport::TestCase
  test "can't create nameless" do
    produce = Produce.new
    assert_not produce.valid?
  end

  test 'can save without image' do
    produce = Produce.new(name: 'Banana')
    assert produce.save
  end
end
