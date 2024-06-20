# frozen_string_literal: true

module RuboCop
  module Cop
    module G18xx
      # `any?` without a block compiles to inefficient JavaScript. Use `!empty?`
      # or pass an explicit block looking for non-nil elements instead.
      #
      # @safety
      #   Autocorrection is unsafe because `any?` with no block looks for any
      #   non-nil elements in the array, while `!empty?` looks at the size of
      #   the array, e.g., `[nil].any?` is `false` but `![nil].empty?` is true.
      #
      # @example
      #   # bad
      #   something.any?
      #
      #   # good
      #   !something.empty?
      #
      #   # good
      #   something.any? { |x| x }
      class NoBlocklessAny < Base
        extend AutoCorrector

        MSG = '`any?` without a block compiles to inefficient JavaScript. Use '\
              '`!empty?` or pass an explicit block instead.'

        RESTRICT_ON_SEND = %i[any?].freeze

        def_node_matcher :any?, <<~PATTERN
            (send $(...) :any?)
        PATTERN

        def_node_matcher :block?, <<~PATTERN
            (block ...)
        PATTERN

        def on_send(node)
          return unless (expression = any?(node))
          return if block?(node.parent)

          add_offense(node) do |corrector|
            corrector.replace(node, "!#{expression.source}.empty?")
          end
        end
      end
    end
  end
end
