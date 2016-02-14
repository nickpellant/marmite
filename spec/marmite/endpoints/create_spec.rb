# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Marmite::Endpoints::Create, type: :mixin do
  subject(:tests_controller) { TestsController.new }

  let(:resource_name) { 'Test' }
  let(:resource_constant) { class_double(resource_name) }

  before(:example) do
    class TestsController
      include Marmite::Controller

      create_endpoint
    end
  end

  it { expect(tests_controller).to be_a(Marmite::Endpoints::Create) }

  describe '#create' do
    subject(:create) { tests_controller.create }

    context 'when using the default service' do
      let(:create_endpoint_service) do
        instance_spy(Marmite::Services::CreateEndpoint)
      end

      before(:example) do
        expect(Marmite::Services::CreateEndpoint).to(
          receive(:new)
          .with(
            controller: tests_controller,
            attributes: {}
          )
          .and_return(create_endpoint_service)
        )

        create
      end

      it { expect(tests_controller).to be_a(Marmite::Endpoints::Create) }

      it 'calls the CreateEndpoint service' do
        expect(create_endpoint_service).to have_received(:call)
      end
    end

    context 'when using a custom service' do
      before(:example) do
        class CreateTest < Marmite::Services::CreateEndpoint
        end

        class TestsController
          include Marmite::Controller

          create_endpoint(service: CreateTest)
        end
      end

      subject(:create) { tests_controller.create }

      let(:create_test) do
        instance_spy(CreateTest)
      end

      before(:example) do
        expect(CreateTest).to(
          receive(:new)
          .with(
            controller: tests_controller,
            attributes: {}
          )
          .and_return(create_test)
        )

        create
      end

      it { expect(tests_controller).to be_a(Marmite::Endpoints::Create) }

      it 'calls the CreateTest service' do
        expect(create_test).to have_received(:call)
      end
    end
  end

  describe '#create_conflict' do
    subject(:create_conflict) do
      tests_controller.create_conflict(resource: resource)
    end

    let(:resource) { instance_spy('Test') }

    it 'renders the response' do
      json_errors = {
        errors: [
          {
            title: 'The resource you were creating failed validation.',
            status: :conflict,
            details: resource.errors
          }
        ]
      }

      expect(tests_controller).to(
        receive(:render).with(json: json_errors, status: :conflict)
      )
    end

    after(:example) { create_conflict }
  end

  describe '#create_created' do
    subject(:create_created) do
      tests_controller.create_created(resource: resource)
    end

    let(:resource) { instance_spy('Test') }

    it 'renders the response' do
      expect(tests_controller).to(
        receive(:render).with(json: resource, status: :created)
      )
    end

    after(:example) { create_created }
  end
end
