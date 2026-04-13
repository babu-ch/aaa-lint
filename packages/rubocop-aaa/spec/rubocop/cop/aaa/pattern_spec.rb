require_relative '../../../spec_helper'

RSpec.describe RuboCop::Cop::AAA::Pattern, :config do
  let(:config) { RuboCop::Config.new('AAA/Pattern' => cop_config) }
  let(:cop_config) { {} }

  def inspect(source)
    processed = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
    cop = described_class.new(config)
    commissioner = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
    commissioner.investigate(processed).offenses
  end

  def autocorrect(source)
    processed = RuboCop::ProcessedSource.new(source, RUBY_VERSION.to_f)
    cop = described_class.new(config)
    commissioner = RuboCop::Cop::Commissioner.new([cop], [], raise_error: true)
    report = commissioner.investigate(processed)
    corrector = RuboCop::Cop::Corrector.new(processed)
    report.offenses.each do |offense|
      corrector.merge!(offense.corrector) if offense.corrector
    end
    corrector.process
  end

  context 'with default config' do
    it 'accepts a block with arrange/act/assert in order' do
      offenses = inspect(<<~RUBY)
        it 'adds' do
          # arrange
          a = 1
          # act
          b = a + 1
          # assert
          expect(b).to eq(2)
        end
      RUBY
      expect(offenses).to be_empty
    end

    it 'accepts test (not only it)' do
      offenses = inspect(<<~RUBY)
        test 'works' do
          # arrange
          a = 1
          # act
          b = a
          # assert
          expect(b).to eq(1)
        end
      RUBY
      expect(offenses).to be_empty
    end

    it 'flags missing arrange' do
      offenses = inspect(<<~RUBY)
        it 'missing' do
          # act
          a = 1
          # assert
          expect(a).to eq(1)
        end
      RUBY
      expect(offenses.size).to eq(1)
      expect(offenses.first.message).to include('arrange')
    end

    it 'flags each missing section separately when multiple are missing' do
      offenses = inspect(<<~RUBY)
        it 'missing two' do
          # arrange
          a = 1
        end
      RUBY
      messages = offenses.map(&:message).join("\n")
      expect(offenses.size).to eq(2)
      expect(messages).to include('"act"')
      expect(messages).to include('"assert"')
    end

    it 'auto-corrects when all three sections are missing' do
      source = <<~RUBY
        it 'all missing' do
          a = 1
          b = a + 1
          expect(b).to eq(2)
        end
      RUBY
      offenses = inspect(source)
      expect(offenses.size).to eq(1)
      expect(offenses.first.message).to include('Missing arrange/act/assert')

      corrected = autocorrect(source)
      expect(corrected).to include('# arrange')
      expect(corrected).to include('# act')
      expect(corrected).to include('# assert')
      # Template is inserted before the existing statements.
      arrange_idx = corrected.index('# arrange')
      a_idx = corrected.index('a = 1')
      expect(arrange_idx).to be < a_idx
    end

    it 'flags wrong order' do
      offenses = inspect(<<~RUBY)
        it 'wrong order' do
          # act
          b = 1
          # arrange
          a = 0
          # assert
          expect(b).to eq(1)
        end
      RUBY
      expect(offenses.size).to eq(1)
      expect(offenses.first.message).to include('order')
    end

    it 'ignores non-test blocks' do
      offenses = inspect(<<~RUBY)
        describe 'group' do
          shared = 1
        end
      RUBY
      expect(offenses).to be_empty
    end

    it 'is case insensitive by default' do
      offenses = inspect(<<~RUBY)
        it 'caps' do
          # ARRANGE
          a = 1
          # Act
          b = a
          # assert
          expect(b).to eq(1)
        end
      RUBY
      expect(offenses).to be_empty
    end
  end

  context 'with Japanese labels' do
    let(:cop_config) do
      {
        'Labels' => {
          'arrange' => %w[準備 前準備],
          'act' => %w[実行],
          'assert' => %w[検証 確認]
        }
      }
    end

    it 'accepts Japanese wording' do
      offenses = inspect(<<~RUBY)
        it 'jp' do
          # 準備
          a = 1
          # 実行
          b = a + 1
          # 検証
          expect(b).to eq(2)
        end
      RUBY
      expect(offenses).to be_empty
    end
  end

  context 'with AllowEmptySection: false' do
    let(:cop_config) { { 'AllowEmptySection' => false } }

    it 'flags an empty arrange section' do
      offenses = inspect(<<~RUBY)
        it 'empty arrange' do
          # arrange
          # act
          a = 1
          # assert
          expect(a).to eq(1)
        end
      RUBY
      expect(offenses.map(&:message).join).to include('arrange')
    end
  end

  context 'with CaseSensitive: true' do
    let(:cop_config) { { 'CaseSensitive' => true } }

    it 'rejects uppercase labels' do
      offenses = inspect(<<~RUBY)
        it 'caps' do
          # ARRANGE
          a = 1
          # act
          b = a
          # assert
          expect(b).to eq(1)
        end
      RUBY
      expect(offenses.size).to eq(1)
      expect(offenses.first.message).to include('arrange')
    end
  end
end
