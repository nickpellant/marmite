require 'simplecov'
require 'codeclimate-test-reporter'
SimpleCov.start do
  formatter SimpleCov::Formatter::MultiFormatter[
    SimpleCov::Formatter::HTMLFormatter,
    CodeClimate::TestReporter::Formatter
  ]
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'marmite'

I18n.load_path += Dir.glob('lib/marmite/locales/*.yml')
