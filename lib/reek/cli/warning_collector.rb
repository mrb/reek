require 'private_attr/everywhere'
require 'set'

module Reek
  module CLI
    #
    # Collects and sorts smells warnings.
    #
    class WarningCollector
      def initialize
        @warnings_set = Set.new
      end

      def found_smell(warning)
        warnings_set.add(warning)
      end

      def warnings
        warnings_set.sort
      end

      private

      private_attr_reader :warnings_set
    end
  end
end
