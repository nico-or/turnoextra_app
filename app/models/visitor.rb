class Visitor
  attr_reader :user, :user_agent

  def initialize(user:, user_agent:)
    @user = user
    @user_agent = user_agent
  end
end
