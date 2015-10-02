require 'active_support'
require 'active_support/core_ext'
require 'active_support/concern'

require 'marmite/controller'

require 'marmite/endpoints/show'
require 'marmite/mixins/infer_endpoint_resource'
require 'marmite/policies/was_the_resource_found'
require 'marmite/queries/resource_query'
require 'marmite/services/show_endpoint'
require 'marmite/version'
