# CR: [matik] od wersji Ruby 2.0 domyślnym kodowaniem w którym interpretowane są
# pliki źródłowe Ruby jest UTF-8. Nie trzeba już pisać tego magicznego komentarza poniżej

# encoding utf-8


I18n.default_locale = :en
# CR: [garbus] - dlaczego czasami masz namespace :: globali, a czasami bez? przydalaby sie konsekwencja.
LANGUAGES = [
  %w[English en],
  # CR: [garbus] - wystarczy 'Español'.html_safe, bez sensu taka interpolacja
  ["Espa&ntilde;ol".html_safe, 'es']
]
