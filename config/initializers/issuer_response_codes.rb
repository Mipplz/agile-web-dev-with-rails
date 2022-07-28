require 'yaml'

# CR: znów brak konsekwencji w stosowaniu przedrostka ścieżki stałych `::`.
path = File.join(Rails.root, 'config', 'issuer_response_codes.yml')
file_content = File.read(path)

::ISSUER_RESPONSE_CODES = YAML.safe_load(file_content, aliases: true)
