module WorkHelper
  def image_data(theme_id, image_index, current_user_id)
    theme_images = Image.theme_images(theme_id)
    current_image = theme_images[image_index]

    # Проверяем, оценивал ли пользователь это изображение
    user_valued = Value.exists?(user_id: current_user_id, image_id: current_image.id)
    user_value = Value.find_by(user_id: current_user_id, image_id: current_image.id)&.value || 0

    {
      theme_id: theme_id,
      index: image_index,
      images_arr_size: theme_images.size,
      image_id: current_image.id,
      name: current_image.name,
      file: current_image.file,
      user_valued: user_valued,
      value: user_value,
      common_ave_value: current_image.ave_value || 0
    }
  end
end