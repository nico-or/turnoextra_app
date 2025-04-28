class ContactMessagePresenter < ApplicationPresenter
  def email
    super.blank? ? "No Email Provided" : super
  end

  def name
    super.blank? ? "Anonymous" : super
  end
end
