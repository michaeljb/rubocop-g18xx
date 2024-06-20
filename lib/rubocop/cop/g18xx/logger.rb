# frozen_string_literal: true

require 'pry-byebug'

module RuboCop
  module Cop
    module G18xx
      # LOGGER calls with interpolated strings should use a block so that the
      # string is not evaluated unless the log message is printed.
      #
      # @example
      #   # bad
      #   LOGGER.debug "#{@game.current_entity.name}'s turn"
      #
      #   # good
      #   LOGGER.debug { "#{@game.current_entity.name}'s turn" }
      class Logger < Base
        extend AutoCorrector

        MSG = 'Use a block when passing interpolated strings to `LOGGER`.'

        RESTRICT_ON_SEND = %i[debug error fatal info warn].freeze

        def_node_matcher :logger_with_interpolated_str?, <<~PATTERN
          (send $(...) ${:debug | :error | :fatal | :info | :warn} $(dstr ...))
        PATTERN

        def on_send(node)
          logger, method, dstr = logger_with_interpolated_str?(node)

          return unless logger&.source == 'LOGGER'
          return unless method
          return unless dstr

          add_offense(node) do |corrector|
            corrector.replace(node, "LOGGER.#{method} { #{dstr.source} }")
          end
        end
      end
    end
  end
end
