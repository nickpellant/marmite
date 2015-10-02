require 'spec_helper'

RSpec.describe Marmite::Services::ShowEndpoint, type: :service do
  subject(:show_endpoint) do
    described_class.new(
      controller: controller, find_by_conditions: find_by_conditions
    )
  end

  let(:controller) { spy('TestsController') }
  let(:find_by_conditions) { {} }

  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_double(resource_name, all: []) }

  before(:example) do
    stub_const(resource_name, resource_constant)
    allow(controller).to(
      receive_message_chain(:class, :name).and_return('TestsController')
    )
  end

  describe '#call' do
    subject(:call) { show_endpoint.call }

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
        receive(:find_for_show)
        .with(find_by_conditions: find_by_conditions)
        .and_return(resource)
      )
    end

    context 'when the Resource is found' do
      let(:was_the_resource_found_instance) do
        instance_double(Marmite::Policies::WasTheResourceFound, call: true)
      end

      let(:resource) { instance_double(resource_constant) }

      it 'responds to the request with show_ok' do
        expect(controller).to receive(:show_ok).with(resource: resource)
      end
    end

    context 'when the Resource is not found' do
      let(:was_the_resource_found_instance) do
        instance_double(Marmite::Policies::WasTheResourceFound, call: false)
      end

      let(:resource) { nil }

      it 'responds to the request with show_ok' do
        expect(controller).to receive(:show_not_found)
      end
    end

    after(:example) { call }
  end
end
