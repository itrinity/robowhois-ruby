require 'rspec'
require 'robowhois'

unless defined?(SPEC_ROOT)
  SPEC_ROOT = File.expand_path("../", __FILE__)
end

# The fixtures are UTF-8 encoded.
# Make sure Ruby uses the proper encoding.
if RUBY_VERSION < '1.9'
  $KCODE = 'u'
else
  Encoding.default_external = Encoding::UTF_8
  Encoding.default_internal = Encoding::UTF_8
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(SPEC_ROOT, "support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
end
