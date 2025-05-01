require "test_helper"

class StringNormalizationServiceTest < ActiveSupport::TestCase
  test "normalize_string" do
    assert_equal "hello world", StringNormalizationService.normalize_string("Hello World!")
    assert_equal "hello world", StringNormalizationService.normalize_string("HELLO - WORLD ")
    assert_equal "arbol 2da edicion", StringNormalizationService.normalize_string("Árbol: 2da. Edición")
    assert_equal "hello world ingles", StringNormalizationService.normalize_string("Hello World! (Ingles)")
  end

  test "normalize_title" do
    assert_equal "hello world", StringNormalizationService.normalize_title("Hello World! Español ")
    assert_equal "hello world", StringNormalizationService.normalize_title("HELLO - WORLD (ingles)")
    assert_equal "arbol 2da edicion", StringNormalizationService.normalize_title("Árbol: 2da. Edición")
    assert_equal "el espanol de al lado", StringNormalizationService.normalize_title("El español de al lado")
  end
end
