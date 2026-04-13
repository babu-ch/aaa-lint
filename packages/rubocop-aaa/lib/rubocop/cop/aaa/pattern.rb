module RuboCop
  module Cop
    module AAA
      class Pattern < Base
        SECTIONS = %i[arrange act assert].freeze

        MSG_MISSING = 'Missing "%<section>s" comment in test block.'.freeze
        MSG_ORDER   = 'AAA comments must appear in order: arrange -> act -> assert.'.freeze
        MSG_EMPTY   = 'Section "%<section>s" has no statements.'.freeze

        DEFAULT_LABELS = {
          'arrange' => %w[arrange],
          'act'     => %w[act],
          'assert'  => %w[assert]
        }.freeze

        DEFAULT_TEST_FUNCTIONS = %w[it test specify example].freeze

        def on_block(node)
          return unless test_method?(node.method_name)

          found = collect_sections(node)
          seen = {}
          found.each { |section, comment| seen[section] ||= comment }

          SECTIONS.each do |section|
            unless seen[section]
              add_offense(node, message: format(MSG_MISSING, section: section))
              return
            end
          end

          ordered = SECTIONS.map { |s| seen[s] }
          (1...ordered.size).each do |i|
            if ordered[i].loc.expression.begin_pos < ordered[i - 1].loc.expression.begin_pos
              add_offense(ordered[i], message: MSG_ORDER)
              return
            end
          end

          return if allow_empty_section?

          check_empty_sections(node, seen)
        end
        alias on_numblock on_block

        private

        def collect_sections(node)
          block_range = node.loc.expression
          processed_source.comments.each_with_object([]) do |comment, acc|
            pos = comment.loc.expression.begin_pos
            next unless pos > block_range.begin_pos && pos < block_range.end_pos

            section = match_section(comment_body(comment))
            acc << [section, comment] if section
          end
        end

        def check_empty_sections(node, seen)
          block_end = node.loc.end.begin_pos
          boundaries = [
            [:arrange, seen[:arrange].loc.expression.end_pos, seen[:act].loc.expression.begin_pos],
            [:act,     seen[:act].loc.expression.end_pos,     seen[:assert].loc.expression.begin_pos],
            [:assert,  seen[:assert].loc.expression.end_pos,  block_end]
          ]

          boundaries.each do |section, start_pos, end_pos|
            next if has_code_between?(start_pos, end_pos)

            add_offense(seen[section], message: format(MSG_EMPTY, section: section))
          end
        end

        def has_code_between?(start_pos, end_pos)
          return false if start_pos >= end_pos

          between = processed_source.raw_source[start_pos...end_pos].to_s
          between.each_line.any? do |line|
            stripped = line.strip
            !stripped.empty? && !stripped.start_with?('#')
          end
        end

        def match_section(text)
          normalized = case_sensitive? ? text : text.downcase
          SECTIONS.each do |section|
            candidates = labels[section.to_s] || []
            candidates.each do |label|
              target = case_sensitive? ? label : label.downcase
              return section if normalized == target
            end
          end
          nil
        end

        def comment_body(comment)
          comment.text.sub(/\A#\s*/, '').strip
        end

        def test_method?(name)
          test_functions.include?(name.to_s)
        end

        def test_functions
          cop_config.fetch('TestFunctions', DEFAULT_TEST_FUNCTIONS)
        end

        def labels
          cop_config.fetch('Labels', DEFAULT_LABELS)
        end

        def case_sensitive?
          cop_config.fetch('CaseSensitive', false)
        end

        def allow_empty_section?
          cop_config.fetch('AllowEmptySection', true)
        end
      end
    end
  end
end
