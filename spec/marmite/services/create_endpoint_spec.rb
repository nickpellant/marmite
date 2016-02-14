require 'spec_helper'

RSpec.describe Marmite::Services::CreateEndpoint, type: :service do
  subject(:create_endpoint) do
    described_class.new(attributes: attributes, controller: controller)
  end

  let(:attributes) { {} }
  let(:controller) { spy('TestsController') }

  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_spy(resource_name, new: resource) }
  let(:resource) { instance_double(resource_name, save: double) }

  let(:record_invalid_name) { 'ActiveRecord::RecordInvalid' }
  let(:record_invalid_constant) { Exception }

  before(:example) do
    stub_const(resource_name, resource_constant)
    stub_const(record_invalid_name, record_invalid_constant)

    expect(resource_constant).to receive(:transaction).and_yield
    allow(controller).to(
      receive_message_chain(:class, :name).and_return('TestsController')
    )
  end

  describe '#call' do
    subject(:call) { create_endpoint.call }

    context 'when the Resource is created' do
      before(:example) do
        expect(resource).to receive(:save!).and_return(true)
      end

      it 'responds to the request with create_created' do
        expect(controller).to receive(:create_created).with(resource: resource)
      end

      context 'when a before_validation hook has been set' do
        let(:create_endpoint) do
          class CustomCreateEndpoint < Marmite::Services::CreateEndpoint
            before_validation :test_method
          end
          CustomCreateEndpoint.new(
            attributes: attributes, controller: controller
          )
        end

        it { expect(create_endpoint).to receive(:test_method) }
      end
    end

    context 'when the Resource has errors' do
      before(:example) do
        expect(resource).to(
          receive(:save!).and_raise(ActiveRecord::RecordInvalid)
        )
      end

      it 'responds to the request with create_conflict' do
        expect(controller).to receive(:create_conflict).with(resource: resource)
      end
    end

    after(:example) { call }
  end
end
