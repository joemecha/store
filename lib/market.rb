class Market
  attr_reader :name,
              :vendors,
              :date

  def initialize(name)
    @name = name
    @vendors = []
    @date = Date.today.strftime("%d/%m/%Y")
  end

  def add_vendor(vendor)
    @vendors << vendor
  end

  def vendor_names
    @vendors.map do |vendor|
      vendor.name
    end
  end

  def vendors_that_sell(item)
    @vendors.find_all do |vendor|
      vendor.check_stock(item) > 0
    end
  end

  def sorted_item_list
    items = self.all_items
    items.map do |item|
      item.name
    end.uniq
       .sort
  end

  def total_inventory
    inventory = {}
    items = self.all_items
    items.each do |item|
      inventory[item] = {
                          quantity: self.get_quantity(item),
                          vendors: vendors_that_sell(item)
                         }
    end
    inventory
  end

  def all_items
    items = @vendors.map do |vendor|
      vendor.inventory.keys
    end.flatten
  end

  def get_quantity(item)
    vendors_that_sell(item).sum { |vendor| vendor.check_stock(item) }
  end

  def overstocked_items
    all_items.find_all do |item|
      get_quantity(item) > 50
    end.uniq
  end

  def sell(item, quantity)
    if item.nil? || get_quantity(item) < quantity
      return false
    else
      until quantity == 0
        vendors_that_sell(item).each do |vendor|
          if vendor.inventory[item] >= quantity
            vendor.inventory[item] -= quantity
            quantity = 0
            break
          else
            quantity -= vendor.inventory[item]
            vendor.inventory[item] = 0
          end
        end
      end
      return true
    end
  end
end
