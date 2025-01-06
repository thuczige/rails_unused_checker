# frozen_string_literal: true

module RailsUnusedChecker
  class Views
    class << self
      def not_used
        views_dir = File.join(Dir.pwd, 'app', 'views')
        view_files = []

        Find.find(views_dir) do |path|
          next if !File.file?(path) || path.include?('_mailer/')

          view_files << path unless File.basename(path).start_with?('_')
        end

        view_files.map do |path|
          next path if path.include?('/mobile/') || path.include?('/02/')

          next if path.include?("/errors/") || path.include?("ios_app") || path.include?('.js.erb') || path.include?('/useful/')

          controller, action = parse_view_path(path)
          next if ['failed_create'].include?(action)

          begin
            controller_class = "#{controller.camelize}Controller".constantize
            path unless controller_class.instance_methods(false).map(&:to_s).include?(action)
          rescue NameError
            path
          end
        end.compact
      end

      def parse_view_path(path)
        relative_path = path.sub(Rails.root.join('app/views/').to_s, '')
        parts = relative_path.split('/')
        controller = parts[0...-1].join('/').sub('/01/pc', '').sub('/01/smart_phone', '')
        controller = controller.sub('/01', '') if controller.include?('admin/') || controller.include?('agent/')
        action = parts[-1].split('.').first
        [controller, action]
      end
    end
  end
end
