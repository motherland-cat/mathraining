# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Ombtraining::Application.initialize!

# Localization
Ombtraining::Application.config.i18n.available_locales = :fr