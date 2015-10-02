require 'spec_helper'

RSpec.describe Marmite::Endpoints::Show, type: :mixin do
  subject(:tests_controller) { TestsController.new }

  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_double(resource_name) }

  before(:example) do
    class TestsController
      include Marmite::Controller

      show_endpoint

      def show_params
        {}
      end
    end
  end

  it { expect(tests_controller).to be_a(Marmite::Endpoints::Show) }

  describe '#show' do
    subject(:show) { tests_controller.show }

    let(:show_endpoint_service) do
      instance_spy(Marmite::Services::ShowEndpoint)
    end

    before(:example) do
      expect(Marmite::Services::ShowEndpoint).to(
        receive(:new)
        .with(
          controller: tests_controller, find_by_conditions: {}
        )
        .and_return(show_endpoint_service)
      )

      show
    end

    it { expect(tests_controller).to be_a(Marmite::Endpoints::Show) }

    it 'calls the ShowEndpoint service' do
      expect(show_endpoint_service).to have_received(:call)
    end
  end

  describe '#show_ok' do
    subject(:show_ok) { tests_controller.show_ok(resource: resource) }

    let(:resource) { instance_spy('Test') }

    it 'renders the response' do
      expect(tests_controller).to(
        receive(:render).with(json: resource, status: :ok)
      )
    end

    after(:example) { show_ok }
  end

  describe '#show_not_found' do
    subject(:show_not_found) { tests_controller.show_not_found }

    it 'renders the response' do
      expect(tests_controller).to(
        receive(:render).with(json: {}, status: :not_found)
      )
    end

    after(:example) { show_not_found }
  end
end
