class ImpressionValidator
  def initialize(user:, user_agent:)
    @user = user
    @user_agent = user_agent
  end

  def worthy?
    return false if is_admin?
    return false if is_bot?

    true
  end

  private

  attr_reader :user, :user_agent

  def is_admin?
    user&.admin?
  end

  def is_bot?
    Browser.new(user_agent).bot?
  end
end
