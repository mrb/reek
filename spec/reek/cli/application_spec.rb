require_relative '../../spec_helper'
require_lib 'reek/cli/application'

RSpec.describe Reek::CLI::Application do
  describe '#initialize' do
    it 'works' do
      Reek::CLI::Application.new []
    end
  end
end
