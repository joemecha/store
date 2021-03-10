require 'minitest/autorun'
require 'minitest/pride'
require './lib/item'
require './lib/vendor'

class VendorTest < Minitest::Test
  def setup
    @item1 = Item.new({name: 'Peach', price: "$0.75"})
    @item2 = Item.new({name: 'Tomato', price: '$0.50'})
    @vendor = Vendor.new("Rocky Mountain Fresh")
  end

  def test_vendors_have_attributes
    assert_equal "Rocky Mountain Fresh", @vendor.name
  end

  def test_begins_with_no_inventory
    expected = ({})
    assert_equal expected, @vendor.inventory
  end

  def test_check_stock
    assert_equal 0, @vendor.check_stock(@item1)
  end

  def test_stock
    @vendor.stock(@item1, 30)
    assert_equal 30, @vendor.check_stock(@item1)

    @vendor.stock(@item1, 25)
    assert_equal 55, @vendor.check_stock(@item1)
  end

  def test_inventory
    @vendor.stock(@item1, 30)
    @vendor.stock(@item1, 25)
    @vendor.stock(@item2, 12)
    expected = {
                @item1 => 55,
                @item2 => 12
                }
    assert_equal expected, @vendor.inventory
  end
end
