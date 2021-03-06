require 'private_attr/everywhere'

module Reek
  module Context
    # Responsible for tracking visibilities in regards to CodeContexts.
    class VisibilityTracker
      private_attr_accessor :tracked_visibility

      VISIBILITY_MODIFIERS = [:private, :public, :protected, :module_function]
      VISIBILITY_MAP = { public_class_method: :public, private_class_method: :private }

      def initialize
        @tracked_visibility = :public
      end

      # Handle the effects of a visibility modifier.
      #
      # @example Modifying the visibility of existing children
      #   track_visibility children, :private, [:hide_me, :implementation_detail]
      #
      # @param children [Array<CodeContext>]
      # @param visibility [Symbol]
      # @param names [Array<Symbol>]
      #
      def track_visibility(children: raise, visibility: raise, names: raise)
        return unless VISIBILITY_MODIFIERS.include? visibility
        if names.any?
          children.each do |child|
            child.visibility = visibility if names.include?(child.name)
          end
        else
          self.tracked_visibility = visibility
        end
      end

      # Handle the effects of a singleton visibility modifier. These can only
      # be used to modify existing children.
      #
      # @example
      #   track_singleton_visibility children, :private_class_method,
      #     [:hide_me, :implementation_detail]
      #
      # @param children [Array<CodeContext>]
      # @param visibility [Symbol]
      # @param names [Array<Symbol>]
      #
      def track_singleton_visibility(children: raise, visibility: raise, names: raise)
        return if names.empty?
        visibility = VISIBILITY_MAP[visibility]
        return unless visibility
        track_visibility children: children, visibility: visibility, names: names
      end

      # Sets the visibility of a child CodeContext to the tracked visibility.
      #
      # @param child [CodeContext]
      #
      def set_child_visibility(child)
        child.apply_current_visibility tracked_visibility
      end
    end
  end
end
