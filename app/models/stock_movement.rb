class StockMovement < ApplicationRecord
  belongs_to :inventory_item
  belongs_to :warehouse
  belongs_to :employee, class_name: "Hr::Employee", optional: true
  belongs_to :project, optional: true
  belongs_to :task, optional: true

  enum :movement_type, { inbound: 0, outbound: 1, adjustment: 2 }

  validates :movement_type, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :unit_cost, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  after_create :enqueue_apply_job

  # convenience: who performed this movement
  def performed_by
    employee
  end

  private

  def enqueue_apply_job
    Inventory::ApplyMovementJob.perform_later(id)
  end
end
