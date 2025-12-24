class ImpressionValidator
  def initialize(user:)
    @user = user
  end

  def worthy?
    return false if is_admin?

    true
  end

  private

  attr_reader :user

  def is_admin?
    user&.admin?
  end
end
