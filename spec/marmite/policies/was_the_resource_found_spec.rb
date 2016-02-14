# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Marmite::Policies::WasTheResourceFound, type: :policy do
  subject(:was_the_resource_found) { described_class.new(resource: resource) }

  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_double(resource_name) }

  before(:example) { stub_const(resource_name, resource_constant) }

  describe '#call' do
    subject(:call) { was_the_resource_found.call }

    context 'when the Resource is present' do
      let(:resource) { instance_double(resource_constant, present?: true) }

      it { is_expected.to be(true) }
    end

    context 'when the Resource is not present' do
      let(:resource) { instance_double(resource_constant, present?: false) }

      it { is_expected.to be(false) }
    end
  end
end
