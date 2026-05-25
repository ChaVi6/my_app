class Value < ApplicationRecord
  belongs_to :user
  belongs_to :image

  after_save :update_image_average
  after_destroy :update_image_average

  validates :value, presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 1,
              less_than_or_equal_to: 10
            }

  def update_image_average
    image.update_average_value
  end

  def self.user_valued_exists(user_id, image_id)
    value_record = find_by(user_id: user_id, image_id: image_id)
    if value_record
      [true, value_record.value]
    else
      [false, nil]
    end
  end
end