require 'pathname'

require 'simplecov'

SimpleCov.start do
  track_files 'lib/**/*.rb'
  add_filter 'lib/reek/version.rb' # version.rb is loaded too early to test
end

if ENV['FAIL_ON_LOW_COVERAGE'] == '1'
  SimpleCov.at_exit do
    SimpleCov.result.format!
    SimpleCov.minimum_coverage 98.71
    SimpleCov.minimum_coverage_by_file 60
  end
end

require_relative '../lib/reek'
require_relative '../lib/reek/spec'
require_relative '../lib/reek/ast/ast_node_class_map'
require_relative '../lib/reek/configuration/app_configuration'

Reek::CLI::Silencer.silently do
  require 'factory_girl'
  begin
    require 'pry-byebug'
  rescue LoadError # rubocop:disable Lint/HandleExceptions
  end
end
if Gem.loaded_specs['factory_girl'].version > Gem::Version.create('4.5.0')
  raise 'Remove the above silencer as well as this check now that ' \
        '`factory_girl` gem is updated to version greater than 4.5.0!'
end

FactoryGirl.find_definitions

SAMPLES_PATH = Pathname.new("#{__dir__}/samples").relative_path_from(Pathname.pwd)

# Simple helpers for our specs.
module Helpers
  def test_configuration_for(config)
    if config.is_a? Pathname
      configuration = Reek::Configuration::AppConfiguration.from_path(config)
    elsif config.is_a? Hash
      configuration = Reek::Configuration::AppConfiguration.from_map default_directive: config
    else
      raise "Unknown config given in `test_configuration_for`: #{config.inspect}"
    end
    configuration
  end

  # @param code [String] The given code.
  #
  # @return syntax_tree [Reek::AST::Node]
  def syntax_tree(code)
    Reek::Source::SourceCode.from(code).syntax_tree
  end

  # :reek:UncommunicativeMethodName
  def sexp(type, *children)
    @klass_map ||= Reek::AST::ASTNodeClassMap.new
    @klass_map.klass_for(type).new(type, children)
  end
end

RSpec.configure do |config|
  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.include FactoryGirl::Syntax::Methods
  config.include Helpers

  config.disable_monkey_patching!

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end

private

def require_lib(path)
  require_relative "../lib/#{path}"
end
