class WorkController < ApplicationController
  include WorkImage

  def index
    @selected_theme = I18n.t('work.index.select_theme')
    @selected_image_name = ""
    @default_image_path = "/assets/images/pictures/gb.jpg"
    @current_locale = I18n.locale

    # Общее количество оценок ВСЕХ пользователей в системе
    @total_all_values = Value.count
  end

  def choose_theme
    @themes = Theme.all.pluck(:name)
    respond_to do |format|
      format.js
      format.html { render partial: 'work/choose_theme_from_arr', layout: false }
    end
  end

  def display_theme
    theme_name = params[:theme]
    theme = Theme.find_by(name: theme_name)

    if theme
      images = Image.where(theme_id: theme.id)
      if images.any?
        image_data = show_image(theme.id, 0)

        @image_data = {
          theme: theme_name,
          index: image_data[:index],
          name: image_data[:name],
          file: image_data[:file],
          image_id: image_data[:image_id],
          theme_id: theme.id,
          images_arr_size: images.size,
          values_qty: image_data[:values_qty],
          user_value: image_data[:value],
          common_ave_value: image_data[:common_ave_value]
        }
      end
    end
    respond_to :js
  end

  def next_image
    theme_id = params[:theme_id].to_i
    current_index = params[:index].to_i
    length = params[:length].to_i

    new_index = next_index(current_index, length)
    @image_data = show_image(theme_id, new_index)
    @image_data[:theme] = Theme.find(theme_id).name
    @image_data[:new_image_index] = new_index
    @image_data[:images_arr_size] = length

    respond_to :js
  end

  def prev_image
    theme_id = params[:theme_id].to_i
    current_index = params[:index].to_i
    length = params[:length].to_i

    new_index = prev_index(current_index, length)
    @image_data = show_image(theme_id, new_index)
    @image_data[:theme] = Theme.find(theme_id).name
    @image_data[:new_image_index] = new_index
    @image_data[:images_arr_size] = length

    respond_to :js
  end

  # НОВЫЙ МЕТОД для общей сводки
  def summary
    @images_with_details = []

    Image.includes(:theme).find_each do |image|
      values_qty = image.values.count
      average_value = image.ave_value || 0
      last_rated_at = image.values.maximum(:created_at)

      # Конвертируем в московское время, если есть
      if last_rated_at.present?
        last_rated_at = last_rated_at.in_time_zone('Europe/Moscow')
      end

      @images_with_details << {
        id: image.id,
        name: image.name,
        file: image.file,
        theme_name: image.theme&.name || 'Без темы',
        average_value: average_value,
        values_count: values_qty,
        last_rated_at: last_rated_at
      }
    end

    @images_with_details = @images_with_details.sort_by { |img| [img[:theme_name], img[:name]] }
  end

  private

  def next_index(index, length)
    return 0 if length == 0
    (index + 1) % length
  end

  def prev_index(index, length)
    return 0 if length == 0
    (index - 1) % length
  end

  def show_image(theme_id, image_index)
    theme_images = Image.theme_images(theme_id)

    if theme_images.empty? || image_index >= theme_images.size || image_index < 0
      return {}
    end

    image = theme_images[image_index]
    values_qty = Value.where(image_id: image.id).count

    {
      index: image_index,
      image_id: image.id,
      name: image.name,
      file: image.file,
      value: 0,
      user_valued: false,
      common_ave_value: image.ave_value || 0,
      values_qty: values_qty
    }
  end
end