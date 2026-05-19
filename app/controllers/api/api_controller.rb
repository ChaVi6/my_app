module Api
  class ApiController < ApplicationController
    include WorkImage  # подключаем модуль с методом show_image

    def next_image
      current_index = params[:index].to_i
      theme_id = params[:theme_id].to_i
      length = params[:length].to_i

      new_index = next_index(current_index, length)
      image_data = show_image(theme_id, new_index)

      respond_to do |format|
        if new_index.blank?
          format.json { render json: { error: I18n.t('api.errors.invalid_index') }, status: :unprocessable_entity }
        else
          format.json do
            render json: {
              new_image_index: image_data[:index],
              name: image_data[:name],
              file: image_data[:file],
              image_id: image_data[:image_id],
              user_value: image_data[:value],
              common_ave_value: image_data[:common_ave_value],
              values_qty: image_data[:values_qty],
              status: "success"
            }
          end
        end
      end
    end

    def prev_image
      current_index = params[:index].to_i
      theme_id = params[:theme_id].to_i
      length = params[:length].to_i

      new_index = prev_index(current_index, length)
      image_data = show_image(theme_id, new_index)

      respond_to do |format|
        if new_index.blank?
          format.json { render json: { error: I18n.t('api.errors.invalid_index') }, status: :unprocessable_entity }
        else
          format.json do
            render json: {
              new_image_index: image_data[:index],
              name: image_data[:name],
              file: image_data[:file],
              image_id: image_data[:image_id],
              user_value: image_data[:value],
              common_ave_value: image_data[:common_ave_value],
              values_qty: image_data[:values_qty],
              status: "success"
            }
          end
        end
      end
    end

    def save_value
      image_id = params[:image_id].to_i
      value = params[:value].to_i
      user_id = current_user.id

      existing_value = Value.find_by(user_id: user_id, image_id: image_id)

      if existing_value
        existing_value.update(value: value)
      else
        Value.create(user_id: user_id, image_id: image_id, value: value)
      end

      image = Image.find(image_id)
      average = image.values.average(:value).to_f.round(1)
      image.update(ave_value: average)

      # 👇 НОВОЕ КОЛИЧЕСТВО ОЦЕНОК ДЛЯ ЭТОГО ИЗОБРАЖЕНИЯ
      values_qty = Value.where(image_id: image_id).count

      render json: {
        status: "success",
        common_ave_value: average,
        values_qty: values_qty,
        message: I18n.t('api.messages.rating_saved')
      }
    end

    def get_image_rating
      image_id = params[:image_id].to_i
      user_id = current_user.id

      # Находим оценку пользователя для этого изображения
      user_value_record = Value.find_by(user_id: user_id, image_id: image_id)
      user_value = user_value_record&.value

      # Получаем среднюю оценку изображения
      image = Image.find(image_id)
      common_ave_value = image.ave_value&.round(1)

      render json: {
        user_value: user_value,
        common_ave_value: common_ave_value || I18n.t('api.messages.no_ratings_yet')
      }
    end

    private

    def next_index(index, length)
      index < length - 1 ? index + 1 : 0
    end

    def prev_index(index, length)
      index > 0 ? index - 1 : length - 1
    end
  end
end