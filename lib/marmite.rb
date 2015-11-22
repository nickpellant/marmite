require 'active_support'
require 'active_support/core_ext'
require 'active_support/concern'

I18n.load_path += Dir.glob(File.dirname(__FILE__) + 'marmite/locales/*.yml')

require 'marmite/mixins/exception_renderer'
require 'marmite/mixins/infer_endpoint_resource'

require 'marmite/endpoints/index'
require 'marmite/endpoints/show'
require 'marmite/endpoints/update'
require 'marmite/policies/was_the_resource_found'
require 'marmite/policies/does_the_resource_have_errors'
require 'marmite/queries/resource_query'
require 'marmite/services/index_endpoint'
require 'marmite/services/show_endpoint'
require 'marmite/services/update_endpoint'
require 'marmite/version'

require 'marmite/controller'
