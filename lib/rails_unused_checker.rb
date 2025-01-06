# frozen_string_literal: true

require_relative "rails_unused_checker/version"
require_relative "rails_unused_checker/routes"
require_relative "rails_unused_checker/action_controllers"
require_relative "rails_unused_checker/views"
require_relative "rails_unused_checker/partials"

module RailsUnusedChecker
  class Error < StandardError; end
end
