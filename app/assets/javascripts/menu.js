// ============================================
//  ІНІЦІАЛІЗАЦІЯ
// ============================================
function ready() {
    initSearch();
    initClearBtn();
}

document.addEventListener('DOMContentLoaded', ready);
document.addEventListener('turbo:load', ready);
document.addEventListener('turbolinks:load', ready);

// ============================================
//  ПОШУК — debounce по закінченню вводу
//  (без фокусу при завантаженні)
// ============================================
var searchDebounceTimer = null;

function initSearch() {
    var search = document.querySelector('#search');
    if (!search) return;

    // 1. Прибираємо фокус — blur одразу після рендеру
    search.blur();

    // 2. Підписуємось на input з debounce 600ms
    search.addEventListener('input', function () {
        clearTimeout(searchDebounceTimer);
        searchDebounceTimer = setTimeout(function () {
            submitSearchForm();
        }, 600);
    });

    // 3. Enter теж відпрацьовує одразу (без debounce)
    search.addEventListener('keydown', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            clearTimeout(searchDebounceTimer);
            submitSearchForm();
        }
    });
}

function submitSearchForm() {
    var form = document.getElementById('filter');
    if (!form) return;

    // Якщо форма remote:true — тригеримо Rails UJS / Turbo submit
    if (typeof Rails !== 'undefined') {
        Rails.fire(form, 'submit');
    } else if (typeof jQuery !== 'undefined') {
        $(form).trigger('submit');
    } else {
        form.submit();
    }
}

// ============================================
//  КНОПКА ОЧИСТИТИ ПОШУК
// ============================================
function initClearBtn() {
    var clearBtn = document.querySelector('#clear-search');
    if (!clearBtn) return;

    clearBtn.addEventListener('click', function (e) {
        e.preventDefault();
        var search = document.getElementById('search');
        if (search) {
            search.value = '';
            submitSearchForm();
        }
    });
}

// ============================================
//  ОНОВЛЕННЯ КІЛЬКОСТІ В КОШИКУ (pop cart)
// ============================================
function inputFieldOnChange(element) {
    var lineItemId = element.id.replace('qty', '');
    var newQuantity = parseFloat(element.value);

    if (!lineItemId || isNaN(newQuantity)) {
        console.error('Invalid data');
        return;
    }

    $.ajax({
        url: '/line_items/' + lineItemId,
        type: 'PATCH',
        dataType: 'script',
        data: {
            pop_cart: true,
            line_item: { new_quantity: newQuantity }
        },
        success: function () {
            console.log('Успішно оновлено');
        },
        error: function (xhr, status, error) {
            console.error('Помилка:', error);
            alert('Не вдалося оновити кількість');
        }
    });
}