require "attributable"
require "rugged"
require "mutiny/domain/unit"
require "mutiny/domain/region"

module Mutiny
  module ChangeDetector
    module Differencer
      class Git
        extend Attributable
        attributes :repository_path, :start_label, :finish_label

        def changed_units
          diff.flat_map do |patch|
            patch.map do |hunk|
              Mutiny::Unit.new(path: path_for(patch), region: region_for(hunk))
            end
          end
        end

        private

        def path_for(patch)
          File.join(repository_path, patch.delta.new_file[:path])
        end

        def region_for(hunk)
          changed_line_numbers = changed_lines_in(hunk).map(&:new_lineno)
          Mutiny::Region.new(
            start_line: changed_line_numbers.min,
            end_line: changed_line_numbers.max
          )
        end

        def changed_lines_in(hunk)
          hunk.lines.select do |line|
            line.new_lineno > 0 &&
              (line.addition? || line.deletion?)
          end
        end

        def diff
          @diff ||= ::Rugged::Repository.new(repository_path).diff(finish_label, start_label)
        end
      end
    end
  end
end
