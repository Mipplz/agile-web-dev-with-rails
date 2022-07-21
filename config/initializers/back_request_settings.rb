require 'yaml'

path = File.join(Rails.root, 'config', 'back_request_settings.yml')
file_content = File.read(path)

BACK_REQUEST_SETTINGS = YAML.load(file_content)
