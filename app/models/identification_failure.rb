class IdentificationFailure < ApplicationRecord
  belongs_to :identifiable, polymorphic: true

  validates :search_method, uniqueness: { scope:  [ :identifiable_type, :identifiable_id ] }
end
