class Image < ApplicationRecord
  belongs_to :theme
  has_many :values

  def update_average_value
    new_avg = values.average(:value).to_f
    update(ave_value: new_avg.round(2))
  end

  scope :theme_images, -> (theme_id) { where(theme_id: theme_id) }
end