# frozen_string_literal: true

RSpec.describe RuboCop::Cop::G18xx::NoBlocklessAny, :config do
  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using any? with no block' do
    expect_offense(<<~RUBY)
      array.any?
      ^^^^^^^^^^ G18xx/NoBlocklessAny: `any?` without a block compiles to inefficient JavaScript. Use `!empty?` or pass an explicit block instead.
    RUBY
  end

  it 'does not register an offense when using `!empty?`' do
    expect_no_offenses(<<~RUBY)
      !array.empty?
    RUBY
  end
end
