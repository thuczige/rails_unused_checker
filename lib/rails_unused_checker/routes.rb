# frozen_string_literal: true

module RailsUnusedChecker
  class Routes
    class << self
      def not_used
        routes = Rails.application.routes.routes
        unused = []

        routes.each do |route|
          path = route.path.spec.to_s.sub('(.:format)', '')
          controller_name = route.defaults[:controller]
          action_name = route.defaults[:action]
          next if controller_name.blank? || action_name.blank? || action_name.to_s.start_with?(':')

          route_info = { path: path, controller: controller_name, action: action_name }

          begin
            controller_class = "#{controller_name}_controller".classify.constantize

            unless controller_class.instance_methods.include?(action_name.to_sym)
              route_info[:error] = 'Action not found'
              unused << route_info
            end
          rescue NameError
            route_info[:error] = 'Controller not found'
            unused << route_info
          end
        end

        unused
      end
    end
  end
end
