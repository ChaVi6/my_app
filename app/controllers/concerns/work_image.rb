module WorkImage
  extend ActiveSupport::Concern
  include WorkHelper  # если нужны вспомогательные методы

  def show_image(theme_id, image_index)
    theme_images = Image.theme_images(theme_id)

    if theme_images.empty? || image_index >= theme_images.size || image_index < 0
      return {}
    end

    one_image_attr = theme_images[image_index].attributes
    image_id = one_image_attr["id"]

    # Временно убираем current_user, ставим заглушку
    # user_valued, value = Value.user_valued_exists(current_user.id, image_id)
    user_valued = false
    value = 0
    common_ave_value = Image.find(image_id).ave_value || 0

    {
      index: image_index,
      values_qty: Value.all.count,
      theme_id: theme_id,
      images_arr_size: theme_images.size,
      image_id: image_id,
      name: one_image_attr["name"],
      file: one_image_attr["file"],
      user_valued: user_valued,
      value: value,
      common_ave_value: common_ave_value
    }
  end
end