require "rails_helper"

RSpec.describe Inventory::ApplyMovementJob, type: :job do
  include ActiveJob::TestHelper

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  after do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  let(:movement) { create(:stock_movement) }

  it "enqueues the job with the stock_movement id" do
    expect {
      Inventory::ApplyMovementJob.perform_later(movement.id)
    }.to have_enqueued_job(Inventory::ApplyMovementJob).with(movement.id)
  end

  it "delegates to Inventory::MovementService#perform! when the movement exists" do
    service_double = instance_double(Inventory::MovementService)
    expect(Inventory::MovementService).to receive(:new).with(movement).and_return(service_double)
    expect(service_double).to receive(:perform!)

    perform_enqueued_jobs do
      Inventory::ApplyMovementJob.perform_later(movement.id)
    end
  end

  it "does nothing when the movement cannot be found" do
    expect(Inventory::MovementService).not_to receive(:new)
    expect {
      Inventory::ApplyMovementJob.perform_now(0) # non-existent id
    }.not_to raise_error
  end
end
