module MoneyHelper
  def format_price(price)
    price = price.price if price.instance_of? Price
    number_to_currency(price, precision: 0, delimiter: ".")
  end
end
