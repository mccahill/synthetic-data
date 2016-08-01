# Load the rails application
require File.expand_path('../application', __FILE__)

# read the credentials file to get runtime secrets
APP_CONFIG = YAML.load_file(Rails.root.join('config', 'synthetic-creds.yml'))[Rails.env]

# Initialize the rails application
Synthetic::Application.initialize!
