class ProjectInventory < ApplicationRecord
  belongs_to :project
  belongs_to :inventory_item
  belongs_to :task, optional: true

  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_commit :touch_inventory_item

  private

  def touch_inventory_item
    inventory_item.touch(:updated_at)
  end
end
