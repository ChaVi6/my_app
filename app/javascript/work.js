// Перелистывание вперёд (правая стрелка)
$(document).on('click', '.img-right-side', function() {
    var themeId = window.currentThemeId;
    var currentIdx = window.currentIndex;
    var length = window.totalImages;

    if (!themeId || currentIdx === undefined || !length) {
        console.log(I18n.t('js.errors.missing_data'));
        return;
    }

    $.ajax({
        type: "GET",
        url: "/api/next_image",
        data: {
            index: currentIdx,
            theme_id: themeId,
            length: length
        },
        dataType: 'json'
    }).done(function(data) {
        console.log(I18n.t('js.success.next'), data);

        // ===== ВАЖНО: ОБНОВЛЯЕМ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ =====
        window.currentIndex = data.new_image_index;
        window.currentImageId = data.image_id;

        // ===== ОБНОВЛЯЕМ ИНТЕРФЕЙС =====
        // Название изображения
        $('.up').html(data.name);

        // Картинка
        var pathImage = "/assets/pictures/" + data.file;
        $('.img-center img').attr('src', pathImage);

        // Форма оценки (показываем оценку пользователя и среднюю)
        $('#user-value').val(data.value || '');
        $('#average-value').html(data.common_ave_value || I18n.t('js.no_ratings_yet'));

        console.log(I18n.t('js.current_image_id'), window.currentImageId);
    }).fail(function(xhr, status, error) {
        console.log(I18n.t('js.errors.next_fail'), error);
    });
});

// Перелистывание назад (левая стрелка)
$(document).on('click', '.img-left-side', function() {
    var themeId = window.currentThemeId;
    var currentIdx = window.currentIndex;
    var length = window.totalImages;

    if (!themeId || currentIdx === undefined || !length) return;

    $.ajax({
        type: "GET",
        url: "/api/prev_image",
        data: {
            index: currentIdx,
            theme_id: themeId,
            length: length
        },
        dataType: 'json'
    }).done(function(data) {
        console.log(I18n.t('js.success.prev'), data);

        // ===== ВАЖНО: ОБНОВЛЯЕМ ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ =====
        window.currentIndex = data.new_image_index;
        window.currentImageId = data.image_id;

        // ===== ОБНОВЛЯЕМ ИНТЕРФЕЙС =====
        // Название изображения
        $('.up').html(data.name);

        // Картинка
        var pathImage = "/assets/pictures/" + data.file;
        $('.img-center img').attr('src', pathImage);

        // Форма оценки
        $('#user-value').val(data.value || '');
        $('#average-value').html(data.common_ave_value || I18n.t('js.no_ratings_yet'));

        console.log(I18n.t('js.current_image_id'), window.currentImageId);
    }).fail(function(xhr, status, error) {
        console.log(I18n.t('js.errors.prev_fail'), error);
    });
});

// Сохранение оценки
$(document).on('click', '#save-value-btn', function() {
    var value = $('#user-value').val();
    var imageId = window.currentImageId;

    console.log(I18n.t('js.saving_for'), imageId, I18n.t('js.value'), value);

    if (!value || value < 1 || value > 10) {
        alert(I18n.t('js.errors.invalid_rating'));
        return;
    }

    $.ajax({
        type: "POST",
        url: "/api/save_value",
        data: {
            image_id: imageId,
            value: value
        },
        dataType: 'json'
    }).done(function(data) {
        console.log(I18n.t('js.success.rating_saved'), data);
        $('#average-value').html(data.common_ave_value || I18n.t('js.no_ratings_yet'));
        alert(I18n.t('js.success.rating_saved_message'));
    }).fail(function(xhr, status, error) {
        console.log(I18n.t('js.errors.save_fail'), error);
        alert(I18n.t('js.errors.save_fail_message'));
    });
});