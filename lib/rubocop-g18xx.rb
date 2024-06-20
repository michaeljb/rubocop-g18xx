# frozen_string_literal: true

require 'rubocop'

require_relative 'rubocop/g18xx'
require_relative 'rubocop/g18xx/version'
require_relative 'rubocop/g18xx/inject'

RuboCop::G18xx::Inject.defaults!

require_relative 'rubocop/cop/g18xx_cops'
