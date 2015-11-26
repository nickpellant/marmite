require 'spec_helper'

RSpec.describe Marmite::Endpoints::Index, type: :mixin do
  subject(:tests_controller) { TestsController.new }

  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_double(resource_name) }

  before(:example) do
    class TestsController
      include Marmite::Controller

      index_endpoint
    end
  end

  it { expect(tests_controller).to be_a(Marmite::Endpoints::Index) }

  describe '#index' do
    subject(:index) { tests_controller.index }

    let(:index_endpoint_service) do
      instance_spy(Marmite::Services::IndexEndpoint)
    end

    before(:example) do
      expect(Marmite::Services::IndexEndpoint).to(
        receive(:new)
        .with(
          controller: tests_controller, filter_conditions: {}
        )
        .and_return(index_endpoint_service)
      )

      index
    end

    it { expect(tests_controller).to be_a(Marmite::Endpoints::Index) }

    it 'calls the IndexEndpoint service' do
      expect(index_endpoint_service).to have_received(:call)
    end
  end

  describe '#index_ok' do
    subject(:index_ok) { tests_controller.index_ok(resources: resources) }

    let(:resources) { instance_spy('Relation') }

    it 'renders the response' do
      expect(tests_controller).to(
        receive(:render).with(json: resources, status: :ok, include: nil)
      )
    end

    context 'when index_includes are set' do
      before(:example) do
        class TestsController
          private

          def index_includes
            'examples'
          end
        end
      end

      it 'renders the response with the includes' do
        expect(tests_controller).to(
          receive(:render)
          .with(json: resources, status: :ok, include: 'examples')
        )
      end
    end

    after(:example) { index_ok }
  end
end
