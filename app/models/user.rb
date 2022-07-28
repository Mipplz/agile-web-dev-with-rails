class User < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_secure_password
  after_destroy :ensure_an_admin_remains

  # CR: [matik] co to za dziwny error i co ma reprezentować?
  # preferowałbym jakbyś odpowiednio nazwał tę klasę ze względu na konkrenty
  # typ błędu, który reprezentuje np. `DeleteError`
  class Error < StandardError
  end

  private
  def ensure_an_admin_remains
    if User.count.zero?
      raise Error.new "Can't delete last user"
      # CR: [garbus] - nigdy nie pomijaj nawiasów przy zagniezdzonej metodzie!
      # powinno byc raise Error.new("Can't delete last user")
      #
      # Tak samo - bez sensu Error.new. Nie musisz instancjonowac tego obiektu tu,
      # wystarczy raise Error, "Can't delete last user"
      # teraz masz jedną metodę raise, efekt ten sam, a czytelnosc duzo wieksza
    end
  end
end
