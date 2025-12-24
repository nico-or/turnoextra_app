class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :user_agent

  def visitor
    Visitor.new(
      user: user,
      user_agent: user_agent
    )
  end
end
