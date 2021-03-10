require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require 'pry'


class ItemTest < Minitest::Test
  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
  end

  def test_it_exists
    assert_instance_of Item, @item1
  end

  def test_items_have_attributes
    assert_equal "Peach", @item1.name
    assert_equal 0.75, @item1.price
    assert_equal "Tomato", @item2.name
    assert_equal 0.5, @item2.price
  end
end
