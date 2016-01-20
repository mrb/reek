require 'pathname'
require_relative '../../lib/reek/spec'

RSpec.describe 'Reek source code' do
  it 'has no smells' do
    Pathname.glob('lib/**/*.rb').each do |pathname|
      expect(pathname).to_not reek
    end
  end
end
