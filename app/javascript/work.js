// Ждём полной загрузки DOM
$(document).ready(function() {
    console.log("work.js загружен");

    // Обработчик для правой кнопки (следующее)
    $(document).on('click', '.img-right-side', function() {
        console.log("Клик по правой кнопке");

        var themeId = window.currentThemeId;
        var currentIdx = window.currentIndex;
        var length = window.totalImages;

        console.log("Данные:", {themeId, currentIdx, length});

        if (!themeId || currentIdx === undefined || !length) {
            console.log("Не хватает данных. Выберите тему сначала.");
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
            console.log("Успех:", data);
            window.currentIndex = data.new_image_index;
            $('.up').html(data.name);
            var pathImage = "/assets/pictures/" + data.file;
            $('.img-center img').attr('src', pathImage);
        }).fail(function(xhr, status, error) {
            console.log("Ошибка AJAX:", error);
        });
    });

    // Обработчик для левой кнопки (предыдущее)
    $(document).on('click', '.img-left-side', function() {
        console.log("Клик по левой кнопке");

        var themeId = window.currentThemeId;
        var currentIdx = window.currentIndex;
        var length = window.totalImages;

        if (!themeId || currentIdx === undefined || !length) {
            console.log("Не хватает данных");
            return;
        }

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
            console.log("Успех:", data);
            window.currentIndex = data.new_image_index;
            $('.up').html(data.name);
            var pathImage = "/assets/pictures/" + data.file;
            $('.img-center img').attr('src', pathImage);
        }).fail(function(xhr, status, error) {
            console.log("Ошибка AJAX:", error);
        });
    });
});