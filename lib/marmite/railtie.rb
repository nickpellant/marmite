require 'rails'

module Marmite
  # Load translations into Rails
  class Railtie < ::Rails::Railtie
    config.i18n.load_path += Dir.glob(File.dirname(__FILE__) + '/locales/*.yml')
  end
end
