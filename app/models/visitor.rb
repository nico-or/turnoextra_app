class Visitor
  attr_reader :user, :user_agent, :ip_address

  def initialize(user:, user_agent:, ip_address: nil)
    @user = user
    @user_agent = user_agent
    @ip_address = ip_address
  end

  def admin?
    user&.admin?
  end

  def bot?
    Browser.new(user_agent).bot?
  end
end
