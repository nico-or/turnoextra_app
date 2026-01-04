class Current < ActiveSupport::CurrentAttributes
  attribute :user
  attribute :user_agent
  attribute :ip_address

  def visitor
    Visitor.new(
      user: user,
      user_agent: user_agent,
      ip_address: ip_address
    )
  end
end
