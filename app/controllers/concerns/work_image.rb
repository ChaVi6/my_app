module WorkImage
  extend ActiveSupport::Concern
  include WorkHelper

  def show_image(theme_id, image_index)
    theme_images = Image.where(theme_id: theme_id).select(:id, :name, :file, :ave_value)

    return {} if theme_images.empty? || image_index >= theme_images.size

    one_image = theme_images[image_index]
    image_id = one_image.id
    current_user_id = current_user&.id

    # Проверяем, оценивал ли текущий пользователь это изображение
    user_valued, value = Value.user_valued_exists(current_user_id, image_id) if current_user_id

    # 👇 КОЛИЧЕСТВО ОЦЕНОК ДЛЯ ЭТОГО ИЗОБРАЖЕНИЯ (НЕ ДЛЯ ВСЕХ)
    values_qty_for_image = Value.where(image_id: image_id).count

    {
      index: image_index,
      values_qty: values_qty_for_image,
      current_user_id: current_user_id,
      theme_id: theme_id,
      images_arr_size: theme_images.size,
      image_id: image_id,
      name: one_image.name,
      file: one_image.file,
      user_valued: user_valued,
      value: value,
      common_ave_value: one_image.ave_value || 0
    }
    end
end