require 'spec_helper'

RSpec.describe Marmite::Services::UpdateEndpoint, type: :service do
  subject(:update_endpoint) do
    described_class.new(
      attributes: attributes, controller: controller, resource_id: resource_id
    )
  end

  let(:attributes) { {} }
  let(:controller) { spy('TestsController') }
  let(:resource_id) { 1 }

  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_double(resource_name, all: []) }

  before(:example) do
    stub_const(resource_name, resource_constant)
    allow(controller).to(
      receive_message_chain(:class, :name).and_return('TestsController')
    )
  end

  describe '#call' do
    subject(:call) { update_endpoint.call }

    let(:resource_query_instance) do
      instance_double(Marmite::Queries::ResourceQuery)
    end

    before(:example) do
      expect(Marmite::Policies::WasTheResourceFound).to(
        receive(:new)
        .with(resource: resource)
        .and_return(was_the_resource_found_instance)
      )

      expect(Marmite::Queries::ResourceQuery).to(
        receive(:new)
        .with(relation: Test.all)
        .and_return(resource_query_instance)
      )

      expect(resource_query_instance).to(
        receive(:find_for_update)
        .with(resource_id: resource_id)
        .and_return(resource)
      )
    end

    context 'when the Resource is found and updated' do
      let(:was_the_resource_found_instance) do
        instance_double(Marmite::Policies::WasTheResourceFound, call: true)
      end

      let(:does_the_resource_have_errors_instance) do
        instance_double(
          Marmite::Policies::DoesTheResourceHaveErrors, call: false
        )
      end

      let(:resource) { instance_double(resource_constant, update: double) }

      before(:example) do
        expect(Marmite::Policies::DoesTheResourceHaveErrors).to(
          receive(:new)
          .with(resource: resource)
          .and_return(does_the_resource_have_errors_instance)
        )
      end

      it 'responds to the request with update_ok' do
        expect(controller).to receive(:update_ok).with(resource: resource)
      end
    end

    context 'when the Resource is found but has errors' do
      let(:was_the_resource_found_instance) do
        instance_double(Marmite::Policies::WasTheResourceFound, call: true)
      end

      let(:does_the_resource_have_errors_instance) do
        instance_double(
          Marmite::Policies::DoesTheResourceHaveErrors, call: true
        )
      end

      let(:resource) { instance_double(resource_constant, update: double) }

      before(:example) do
        expect(Marmite::Policies::DoesTheResourceHaveErrors).to(
          receive(:new)
          .with(resource: resource)
          .and_return(does_the_resource_have_errors_instance)
        )
      end

      it 'responds to the request with update_conflict' do
        expect(controller).to receive(:update_conflict).with(resource: resource)
      end
    end

    context 'when the Resource is not found' do
      let(:was_the_resource_found_instance) do
        instance_double(Marmite::Policies::WasTheResourceFound, call: false)
      end

      let(:resource) { nil }

      it 'responds to the request with update_ok' do
        expect(controller).to receive(:update_not_found)
      end
    end

    after(:example) { call }
  end
end
