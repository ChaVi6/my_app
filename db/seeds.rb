# Очищаем таблицы
Image.delete_all
Theme.delete_all
User.delete_all
Value.delete_all

# Сбрасываем счётчики ID
ActiveRecord::Base.connection.reset_pk_sequence!('images')
ActiveRecord::Base.connection.reset_pk_sequence!('themes')
ActiveRecord::Base.connection.reset_pk_sequence!('users')
ActiveRecord::Base.connection.reset_pk_sequence!('values')

Theme.create(id: 1, name: "Кто лучший игрок Европы?", qty_items: 0)
Theme.create(id: 2, name: "Кто лучший молодой игрок Европы?", qty_items: 0)
Theme.create(id: 3, name: "Кто лучший россиянин, выступающий заграницей?", qty_items: 0)

Image.create(name: "Пау Кубарси (ФК Барселона, защитник, 19 лет)", file: "cubarsi.jpeg", ave_value: 0, theme_id: 2)
Image.create(name: "Усман Дембеле (ФК ПСЖ, нападающий, 28 лет)", file: "dembele.jpg", ave_value: 0, theme_id: 1)
Image.create(name: "Дезире Дуэ (ФК ПСЖ, полузащитник, 20 лет)", file: "due.jpg", ave_value: 0, theme_id: 2)
Image.create(name: "Уоррен Заир-Эмери (ФК ПСЖ, полузащитник, 20 лет)", file: "emery.jpeg", ave_value: 0, theme_id: 2)
Image.create(name: "Эндрик (ФК Реал Мадрид, нападающий, 19 лет)", file: "endrick.jpg", ave_value: 0, theme_id: 2)
Image.create(name: "Александр Головин (ФК Монако, полузащитник, 29 лет)", file: "golovin.jpg", ave_value: 0, theme_id: 3)
Image.create(name: "Никита Хайкин (ФК Будё-Глимт, вратарь, 30 лет)", file: "haikin.jpg", ave_value: 0, theme_id: 3)
Image.create(name: "Гарри Кейн (ФК Бавария, нападающий, 32 год)", file: "kane.jpg", ave_value: 0, theme_id: 1)
Image.create(name: "Хвича Кварацхелия (ФК ПСЖ, полузащитник, 25 года)", file: "kvara.jpg", ave_value: 0, theme_id: 1)
Image.create(name: "Килиан Мбаппе (ФК Реал Мадрид, нападающий, 27 лет)", file: "mbappe.jpg", ave_value: 0, theme_id: 1)
Image.create(name: "Алексей Миранчук (ФК Атланта, полузащитник, 30 лет)", file: "miranchuk.jpg", ave_value: 0, theme_id: 3)
Image.create(name: "Майкл Олисе (ФК Бавария, полузащитник, 24 года)", file: "olise.jpg", ave_value: 0, theme_id: 1)
Image.create(name: "Матвей Сафонов (ФК ПСЖ, вратарь, 27 лет)", file: "safonov.jpeg", ave_value: 0, theme_id: 3)
Image.create(name: "Ламин Ямаль (ФК Барселона, нападающий, 19 лет)", file: "yamal.jpg", ave_value: 0, theme_id: 2)
Image.create(name: "Арсен Захарян (ФК Реал Сосьедад, полузащитник, 23 год)", file: "zaharyan.jpg", ave_value: 0, theme_id: 3)

User.create(name: "Эксперт", email: "expert@example.com")

(1..15).each do |image_id|
  Value.create(user_id: 1, image_id: image_id, value: rand(3..5))
end

puts "База данных успешно заполнена!"
puts "Тем: #{Theme.count}"
puts "Изображений: #{Image.count}"
puts "Пользователей: #{User.count}"
puts "Оценок: #{Value.count}"