class Visitor
  attr_reader :user, :user_agent, :ip_address

  def initialize(user:, user_agent:, ip_address: nil)
    @user = user
    @user_agent = user_agent
    @ip_address = ip_address
  end

  def impression_worthy?
    return false if is_admin?
    return false if is_bot?

    true
  end

  private

  attr_reader :visitor

  def is_admin?
    user&.admin?
  end

  def is_bot?
    Browser.new(user_agent).bot?
  end
end
