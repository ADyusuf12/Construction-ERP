class ProjectInventory < ApplicationRecord
  belongs_to :project
  belongs_to :inventory_item
  belongs_to :task, optional: true

  # Explicitly validate reserved quantity column
  validates :quantity_reserved, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  after_commit :touch_inventory_item

  # --- Business Logic ---

  # How many units have actually been issued/delivered to the project
  def issued_quantity
    StockMovement.where(
      project: project,
      inventory_item: inventory_item,
      movement_type: [:outbound, :site_delivery]
    ).sum(:quantity)
  end

  # Reservation still outstanding (reserved but not yet delivered)
  def outstanding_reservation
    [quantity_reserved - issued_quantity, 0].max
  end

  # Current stock physically at the project site
  # (later you could subtract consumption/usage if tracked)
  def site_quantity
    issued_quantity
  end

  # --- Scopes ---
  scope :for_item, ->(item) { where(inventory_item: item) }
  scope :for_project, ->(project) { where(project: project) }

  scope :issued, -> {
    joins(:project).where(
      id: StockMovement.select(:inventory_item_id)
                       .where(movement_type: [:outbound, :site_delivery])
    )
  }

  private

  def touch_inventory_item
    inventory_item.touch(:updated_at)
  end
end
