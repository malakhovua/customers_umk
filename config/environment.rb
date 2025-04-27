# Load the Rails application.
require_relative 'application'


# Initialize the Rails application.
Rails.application.initialize!
Rails.logger.debug "Year: #{Time.now.year}" 
