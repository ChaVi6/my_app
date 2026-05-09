class WorkController < ApplicationController
  include WorkImage

  def index
    @selected_theme = "Выберите тему"
    @selected_image_name = ""
    @default_image_path = "/assets/images/pictures/gb.jpg"
    @current_locale = I18n.locale
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

    if theme && theme.images.any?
      @image_data = show_image(theme.id, 0)
      @image_data[:theme] = theme.name
      @image_data[:values_qty] = Value.count
      @image_data[:theme_id] = theme.id
      @image_data[:images_arr_size] = theme.images.count
      respond_to :js
    else
      head :ok
    end
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

    {
      index: image_index,
      image_id: image.id,
      name: image.name,
      file: image.file,
      value: 0,
      user_valued: false,
      common_ave_value: image.ave_value || 0
    }
  end
end