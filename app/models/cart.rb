class Cart < ActiveRecord::Base
  has_many :line_items
  has_many :items, through: :line_items
  belongs_to :user

  def add_item(item_id)
    if item_ids.include?(item_id.to_i)
      current_line_item = line_items.find_by(item_id: item_id)
      current_line_item.quantity += 1
      current_line_item
    else
      line_items.build(item_id: item_id)
    end
  end

  def total
    line_items.inject(0) { |sum, line_item| sum + line_item.total}
  end

  def checkout
    remove_inventory
    user.remove_cart
    update(status: 'submitted')
  end

  private

    def remove_inventory
      line_items.each do |line_item|
        line_item.item.remove(line_item.quantity)
      end
    end

end
