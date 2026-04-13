module RuboCop
  module Cop
    module AAA
      class Pattern < Base
        extend AutoCorrector

        SECTIONS = %i[arrange act assert].freeze

        MSG_MISSING_ALL = 'Missing arrange/act/assert section comments. Insert # %<arrange>s, # %<act>s, and # %<assert>s to mark each section (auto-correct scaffolds a template at the top of the block).'.freeze
        MSG_MISSING_ARRANGE = 'Missing "arrange" comment. Insert # %<label>s before the code that sets up test state.'.freeze
        MSG_MISSING_ACT     = 'Missing "act" comment. Insert # %<label>s before the code that triggers the behavior under test.'.freeze
        MSG_MISSING_ASSERT  = 'Missing "assert" comment. Insert # %<label>s before the code that verifies the result.'.freeze
        MSG_ORDER = 'AAA comments must appear in order: arrange -> act -> assert. Found "%<found>s" after "%<previous>s".'.freeze
        MSG_EMPTY = 'Section "%<section>s" has no statements. Add code between # %<section>s and the next section, or remove the # %<section>s comment.'.freeze

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

          missing = SECTIONS.reject { |s| seen[s] }

          if missing.size == SECTIONS.size
            report_all_missing(node)
            return
          end

          unless missing.empty?
            missing.each { |s| report_missing_one(node, s) }
            return
          end

          ordered = SECTIONS.map { |s| seen[s] }
          (1...ordered.size).each do |i|
            next unless ordered[i].loc.expression.begin_pos < ordered[i - 1].loc.expression.begin_pos

            add_offense(
              ordered[i],
              message: format(MSG_ORDER, found: SECTIONS[i], previous: SECTIONS[i - 1])
            )
            return
          end

          return if allow_empty_section?

          check_empty_sections(node, seen)
        end
        alias on_numblock on_block

        private

        def report_all_missing(node)
          labels_for_template = {
            arrange: preferred_label('arrange'),
            act:     preferred_label('act'),
            assert:  preferred_label('assert')
          }
          message = format(MSG_MISSING_ALL, labels_for_template)

          add_offense(node, message: message) do |corrector|
            insert_template(corrector, node, labels_for_template)
          end
        end

        def report_missing_one(node, section)
          message_template = {
            arrange: MSG_MISSING_ARRANGE,
            act:     MSG_MISSING_ACT,
            assert:  MSG_MISSING_ASSERT
          }[section]
          # Anchor each offense to a distinct location so RuboCop does not dedupe
          # them when multiple sections are missing.
          location = {
            arrange: node.send_node.loc.expression,
            act:     node.loc.begin,
            assert:  node.loc.end
          }[section]
          add_offense(location, message: format(message_template, label: preferred_label(section.to_s)))
        end

        def insert_template(corrector, node, labels_for_template)
          source = processed_source.raw_source
          block_start = node.loc.begin.end_pos # position right after "do" / "{"
          indent = detect_indent(node, block_start)

          template = +"\n#{indent}# #{labels_for_template[:arrange]}"
          template << "\n#{indent}# #{labels_for_template[:act]}"
          template << "\n#{indent}# #{labels_for_template[:assert]}"

          corrector.insert_after(node.loc.begin, template)
        end

        def detect_indent(node, block_start)
          source = processed_source.raw_source
          # Prefer the indentation of the first line of body content.
          tail = source[block_start..-1] || ''
          tail.each_line do |line|
            next if line.strip.empty?

            stripped = line.sub(/^\n/, '')
            match = stripped.match(/\A([ \t]*)\S/)
            return match[1] if match
          end
          # Fallback: use the block's own indent + 2 spaces.
          block_line = source[0...node.loc.expression.begin_pos].rpartition("\n").last
          lead = block_line.match(/\A[ \t]*/)[0]
          "#{lead}  "
        end

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

        def preferred_label(section)
          (labels[section] && labels[section].first) || section
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
