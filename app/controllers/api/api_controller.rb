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
          format.json { render json: { error: "Invalid index" }, status: :unprocessable_entity }
        else
          format.json do
            render json: {
              new_image_index: image_data[:index],
              name: image_data[:name],
              file: image_data[:file],
              image_id: image_data[:image_id],
              user_valued: image_data[:user_valued],
              common_ave_value: image_data[:common_ave_value],
              value: image_data[:value],
              status: "success",
              notice: "Перелистнули к следующему изображению"
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
          format.json { render json: { error: "Invalid index" }, status: :unprocessable_entity }
        else
          format.json do
            render json: {
              new_image_index: image_data[:index],
              name: image_data[:name],
              file: image_data[:file],
              image_id: image_data[:image_id],
              user_valued: image_data[:user_valued],
              common_ave_value: image_data[:common_ave_value],
              value: image_data[:value],
              status: "success",
              notice: "Перелистнули к предыдущему изображению"
            }
          end
        end
      end
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