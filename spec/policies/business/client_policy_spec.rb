require "rails_helper"

RSpec.describe Business::ClientPolicy do
  let(:client) { create(:business_client) }

  context "as CEO" do
    let(:user) { create(:user, :ceo) }
    subject { described_class.new(user, client) }

    it "permits all actions" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end

    it "resolves all clients in scope" do
      scope = described_class::Scope.new(user, Business::Client.all).resolve
      expect(scope).to include(client)
    end
  end

  context "as HR" do
    let(:user) { create(:user, :hr) }
    subject { described_class.new(user, client) }

    it "permits all actions" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(true)
      expect(subject.update?).to eq(true)
      expect(subject.destroy?).to eq(true)
    end

    it "resolves all clients in scope" do
      scope = described_class::Scope.new(user, Business::Client.all).resolve
      expect(scope).to include(client)
    end
  end

  context "as Client user" do
    let(:user) { create(:user, :client, client: client) }
    subject { described_class.new(user, client) }

    it "permits index and show only for own client" do
      expect(subject.index?).to eq(true)
      expect(subject.show?).to eq(true)
      expect(subject.create?).to eq(false)
      expect(subject.update?).to eq(false)
      expect(subject.destroy?).to eq(false)
    end

    it "resolves only own client in scope" do
      other_client = create(:business_client)
      scope = described_class::Scope.new(user, Business::Client.all).resolve
      expect(scope).to include(client)
      expect(scope).not_to include(other_client)
    end
  end

  context "as Engineer" do
    let(:user) { create(:user, :engineer) }
    subject { described_class.new(user, client) }

    it "forbids all actions" do
      expect(subject.index?).to eq(false)
      expect(subject.show?).to eq(false)
      expect(subject.create?).to eq(false)
      expect(subject.update?).to eq(false)
      expect(subject.destroy?).to eq(false)
    end

    it "resolves none in scope" do
      scope = described_class::Scope.new(user, Business::Client.all).resolve
      expect(scope).to be_empty
    end
  end
end
