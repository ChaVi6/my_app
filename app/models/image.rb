class Image < ApplicationRecord
  belongs_to :theme
  has_many :values, dependent: :destroy

  scope :theme_images, -> (theme_id) { where(theme_id: theme_id).select(:id, :name, :file, :ave_value) }

  def update_average_value
    new_ave = values.average(:value)
    update_column(:ave_value, new_ave.round(2)) if new_ave
  end
end