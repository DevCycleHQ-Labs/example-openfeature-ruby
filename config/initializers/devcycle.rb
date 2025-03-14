require 'dotenv'
require 'openfeature-sdk'
Dotenv.load




# Create a client
OFClient = OpenFeature::SDK.build_client

DevCycleClient = DevCycle::Client.new(
  ENV['DEVCYCLE_SERVER_SDK_KEY'],
  DevCycle::Options.new,
  true
)

OpenFeature::SDK.configure do |config|
  config.set_provider(DevCycleClient.open_feature_provider)
end