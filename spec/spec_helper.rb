$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'malartu'
require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    Malartu.apikey = 'apikey123'
  end
end
