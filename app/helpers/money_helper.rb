module MoneyHelper
  def format_price(price)
    price = price.price if price.instance_of? Price
    "$" + price.to_s.reverse.gsub(/(\d{3})(?=\d)/, '\\1.').reverse
  end
end
