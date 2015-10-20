require 'spec_helper'

RSpec.describe Marmite::Controller, type: :mixin do
  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_double(resource_name) }

  before(:example) do
    class TestsController
      include Marmite::Controller
    end
  end

  describe '#show_endpoint' do
    subject(:show_endpoint) { TestsController.show_endpoint }

    it { expect(show_endpoint.new).to be_a(Marmite::Endpoints::Show) }
  end

  describe '#index_endpoint' do
    subject(:index_endpoint) { TestsController.index_endpoint }

    it { expect(index_endpoint.new).to be_a(Marmite::Endpoints::Index) }
  end

  describe '#update_endpoint' do
    subject(:update_endpoint) { TestsController.update_endpoint }

    it { expect(update_endpoint.new).to be_a(Marmite::Endpoints::Update) }
  end
end
