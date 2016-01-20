require_relative '../../spec_helper'
require_lib 'reek/rake/task'

RSpec.describe Reek::Rake::Task do
  describe '#initialize' do
    it 'works' do
      Reek::Rake::Task.new
    end
  end
end
