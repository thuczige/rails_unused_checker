# frozen_string_literal: true

module RailsUnusedChecker
  class Partials
    class << self
      def not_used
        views_dir = File.join(Dir.pwd, 'app', 'views')
        partial_files = []

        Find.find(views_dir) do |path|
          partial_files << path if File.file?(path) && File.basename(path).start_with?('_')
        end

        partial_files.select do |partial|
          next partial if partial.include?("/mobile/")

          partial_name = File.basename(partial).sub(/^_/, '')
          partial_name_without_ext = partial_name.split('.').first
          usage = `grep -r "#{partial_name_without_ext}" #{views_dir}`
          usage.strip.empty?
        end
      end
    end
  end
end
