# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Marmite::Services::IndexEndpoint, type: :service do
  subject(:index_endpoint) do
    described_class.new(
      controller: controller, filter_conditions: filter_conditions
    )
  end

  let(:controller) { spy('TestsController') }
  let(:filter_conditions) { {} }

  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_double(resource_name, all: []) }

  before(:example) do
    stub_const(resource_name, resource_constant)
    allow(controller).to(
      receive_message_chain(:class, :name).and_return('TestsController')
    )
  end

  describe '#call' do
    subject(:call) { index_endpoint.call }

    let(:resource_query_instance) do
      instance_double(Marmite::Queries::ResourceQuery)
    end

    let(:resources_relation) { instance_double('Relation') }

    before(:example) do
      expect(Marmite::Queries::ResourceQuery).to(
        receive(:new)
        .with(relation: Test.all)
        .and_return(resource_query_instance)
      )

      expect(resource_query_instance).to(
        receive(:find_for_index)
        .with(filter_conditions: filter_conditions)
        .and_return(resources_relation)
      )
    end

    it 'responds to the request with index_ok' do
      expect(controller).to(
        receive(:index_ok).with(resources: resources_relation)
      )
    end

    after(:example) { call }
  end
end
