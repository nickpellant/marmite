require 'spec_helper'

RSpec.describe Marmite::Policies::DoesTheResourceHaveErrors, type: :policy do
  subject(:does_the_resource_have_errors) do
    described_class.new(resource: resource)
  end

  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_double(resource_name) }

  before(:example) { stub_const(resource_name, resource_constant) }

  describe '#call' do
    subject(:call) { does_the_resource_have_errors.call }

    context 'when the Resource has errors' do
      let(:resource) do
        instance_double(resource_constant, errors: double(any?: true))
      end

      it { is_expected.to be(true) }
    end

    context 'when the Resource is not present' do
      let(:resource) do
        instance_double(resource_constant, errors: double(any?: false))
      end

      it { is_expected.to be(false) }
    end
  end
end
