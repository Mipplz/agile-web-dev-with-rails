require 'yaml'

path = File.join(Rails.root, 'config', 'baisc_authorization_espago.yml')
file_content = File.read(path)

::BASIC_AUTHORIZATION_ESPAGO = YAML.safe_load(file_content, aliases: true)
