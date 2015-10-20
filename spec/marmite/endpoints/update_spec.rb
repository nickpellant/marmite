require 'spec_helper'

RSpec.describe Marmite::Endpoints::Update, type: :mixin do
  subject(:tests_controller) { TestsController.new }

  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_double(resource_name) }
  let(:resource_id) { 1 }

  before(:example) do
    class TestsController
      include Marmite::Controller

      update_endpoint

      def update_params
        {}
      end

      def params
        { id: 1 }
      end
    end
  end

  it { expect(tests_controller).to be_a(Marmite::Endpoints::Update) }

  describe '#update' do
    subject(:update) { tests_controller.update }

    let(:update_endpoint_service) do
      instance_spy(Marmite::Services::UpdateEndpoint)
    end

    before(:example) do
      expect(Marmite::Services::UpdateEndpoint).to(
        receive(:new)
        .with(
          controller: tests_controller,
          resource_id: resource_id,
          attributes: {}
        )
        .and_return(update_endpoint_service)
      )

      update
    end

    it { expect(tests_controller).to be_a(Marmite::Endpoints::Update) }

    it 'calls the UpdateEndpoint service' do
      expect(update_endpoint_service).to have_received(:call)
    end
  end

  describe '#update_conflict' do
    subject(:update_conflict) do
      tests_controller.update_conflict(resource: resource)
    end

    let(:resource) { instance_spy('Test') }

    it 'renders the response' do
      expect(tests_controller).to(
        receive(:render).with(json: resource, status: :conflict)
      )
    end

    after(:example) { update_conflict }
  end

  describe '#update_ok' do
    subject(:update_ok) { tests_controller.update_ok(resource: resource) }

    let(:resource) { instance_spy('Test') }

    it 'renders the response' do
      expect(tests_controller).to(
        receive(:render).with(json: resource, status: :ok)
      )
    end

    after(:example) { update_ok }
  end

  describe '#update_not_found' do
    subject(:update_not_found) { tests_controller.update_not_found }

    it 'renders the response' do
      expect(tests_controller).to(
        receive(:render).with(json: {}, status: :not_found)
      )
    end

    after(:example) { update_not_found }
  end
end
