require "test_helper"

class StringNormalizationServiceTest < ActiveSupport::TestCase
  test "normalize_string" do
    assert_equal "hello world", Utils.normalize_string("Hello World!")
    assert_equal "hello world", Utils.normalize_string("HELLO - WORLD ")
    assert_equal "arbol 2da edicion", Utils.normalize_string("Árbol: 2da. Edición")
    assert_equal "hello world ingles", Utils.normalize_string("Hello World! (Ingles)")
  end

  test "normalize_title" do
    assert_equal "hello world", Utils.normalize_title("Hello World! Español ")
    assert_equal "hello world", Utils.normalize_title("HELLO - WORLD (ingles)")
    assert_equal "arbol 2da edicion", Utils.normalize_title("Árbol: 2da. Edición")
    assert_equal "el espanol de al lado", Utils.normalize_title("El español de al lado")
  end
end
