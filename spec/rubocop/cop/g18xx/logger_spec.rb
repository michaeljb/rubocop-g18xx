# frozen_string_literal: true

RSpec.describe RuboCop::Cop::G18xx::Logger, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using interpolated strings with LOGGER' do
    expect_offense(<<~RUBY)
      LOGGER.debug "#{foo}"
      ^^^^^^^^^^ Use a block when passing interpolated strings to `LOGGER`.
    RUBY
  end

  it 'does not register an offense when using normal strings' do
    expect_no_offenses(<<~RUBY)
      LOGGER.debug 'foo'
    RUBY
  end

  it 'does not register an offense when using interpolated strings in a block' do
    expect_no_offenses(<<~RUBY)
      LOGGER.debug { "#{foo}" }
    RUBY
  end
end
