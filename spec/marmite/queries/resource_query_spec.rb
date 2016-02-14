# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Marmite::Queries::ResourceQuery, type: :query do
  subject(:resource_query) { described_class.new(relation: relation) }

  let(:relation) { Test.all }

  let(:resource_name) { 'Test' }
  let(:resource_constant) do
    class_double(resource_name, all: resource_constant_all)
  end
  let(:resource_constant_all) do
    resource_constant_all = instance_double('Relation')
    allow(resource_constant_all).to receive(:extending)
    resource_constant_all
  end

  before(:example) { stub_const(resource_name, resource_constant) }

  describe '#find_for_show' do
    subject(:find_for_show) do
      resource_query.find_for_show(find_by_conditions: find_by_conditions)
    end

    let(:find_by_conditions) { {} }

    let(:resource) { instance_double(resource_constant) }

    before(:example) do
      expect(resource_query).to(
        receive_message_chain(:search, :find_by).and_return(resource)
      )
    end

    it { is_expected.to be(resource) }

    after(:example) { find_for_show }
  end

  describe '#find_for_index' do
    subject(:find_for_index) do
      resource_query.find_for_index(filter_conditions: filter_conditions)
    end

    let(:filter_conditions) { {} }

    let(:resources) { instance_double('Relation') }

    before(:example) do
      expect(resource_query).to(
        receive_message_chain(:search, :where).and_return(resources)
      )
    end

    it { is_expected.to be(resources) }

    after(:example) { find_for_index }
  end

  describe '#find_for_update' do
    subject(:find_for_update) do
      resource_query.find_for_update(resource_id: resource_id)
    end

    let(:resource_id) { 1 }

    let(:resource) { instance_double(resource_constant) }

    before(:example) do
      expect(resource_query).to(
        receive_message_chain(:search, :find_by).and_return(resource)
      )
    end

    it { is_expected.to be(resource) }

    after(:example) { find_for_update }
  end
end
