# frozen_string_literal: true

module RailsUnusedChecker
  class ActionControllers
    class << self
      def not_used
        Dir[Rails.root.join('app/controllers/**/*.rb')].reject{|file| file.include?('/concerns/')}.map do |file|
          controller_class = file.sub(Rails.root.join('app/controllers/').to_s, '').sub('.rb', '').camelize.constantize
          next if [ApplicationController, ApplyBaseController, OmniauthCallbacksController].include?(controller_class)

          controller_specific_actions = controller_class.instance_methods(false).map(&:to_s).select do |method|
            controller_class.instance_method(method).source_location.first.include?('/var/www/smocca_v3/current/')
          end

          callbacks = callbacks_for(controller_class)
          actions_in_use = routes_actions(controller_class)
          unused_actions = controller_specific_actions - callbacks - actions_in_use
          unused_actions = unused_actions.reject{|action| action.start_with?('_callback')}
          {controller: controller_class.name, actions: unused_actions} if unused_actions.any?
        end.compact
      end

      private

      def callbacks_for(controller_class)
        return [] unless controller_class.respond_to?(:_process_action_callbacks)

        controller_class._process_action_callbacks.map do |callback|
          callback.filter.to_s if callback.respond_to?(:filter)
        end.compact
      end

      def routes_actions(controller_class)
        routes = Rails.application.routes.routes

        routes.map do |route|
          controller = route.defaults[:controller]
          action = route.defaults[:action]
          next unless controller && action
          next unless controller_class.name == "#{controller.camelize}Controller"

          action
        end.compact
      end
    end
  end
end
