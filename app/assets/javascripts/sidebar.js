// ============================================
//  SIDEBAR TOGGLE
// ============================================
var trigger = $('.hamburger'),
    overlay = $('.overlay'),
    isClosed = false;

trigger.click(function () {
    hamburger_cross();
});

function hamburger_cross() {
    if (isClosed == true) {
        overlay.hide();
        trigger.removeClass('is-open');
        trigger.addClass('is-closed');
        isClosed = false;
    } else {
        overlay.show();
        trigger.removeClass('is-closed');
        trigger.addClass('is-open');
        isClosed = true;
    }
}

function hideMenu() {
    $('#wrapper').toggleClass('menuDisplayed');
    hamburger_cross();
}

$('[data-toggle="offcanvas"]').click(function () {
    $('#wrapper').toggleClass('menuDisplayed');
});

// ============================================
//  PRODUCT TREE
// ============================================
function initTree() {
    // Ховаємо всі .nested напряму через style
    document.querySelectorAll('.nested').forEach(function (el) {
        el.style.display = 'none';
    });

    // Прибираємо старі listeners через clone trick
    document.querySelectorAll('.caret').forEach(function (caret) {
        var newCaret = caret.cloneNode(true);
        caret.parentNode.replaceChild(newCaret, caret);
    });

    // Вішаємо нові listeners
    document.querySelectorAll('.caret').forEach(function (caret) {
        caret.style.cursor = 'pointer';
        caret.addEventListener('click', function (e) {
            e.stopPropagation();

            // Шукаємо .nested безпосередньо всередині батьківського li
            var parentEl = this.parentElement;
            var nested = null;

            // Перебираємо дочірні елементи батька
            for (var i = 0; i < parentEl.children.length; i++) {
                if (parentEl.children[i].classList.contains('nested')) {
                    nested = parentEl.children[i];
                    break;
                }
            }

            if (!nested) return;

            if (nested.style.display === 'block') {
                nested.style.display = 'none';
                this.classList.remove('caret-down');
            } else {
                nested.style.display = 'block';
                this.classList.add('caret-down');
            }
        });
    });
}

// ============================================
//  CHECKBOX TREE
// ============================================
function initCheckboxTree() {
    document.querySelectorAll('input[type="checkbox"]').forEach(function (checkbox) {
        var parentLi = checkbox.closest('li');
        var nestedList = parentLi ? parentLi.querySelector('ul.nested') : null;

        if (nestedList) {
            checkbox.addEventListener('change', function () {
                nestedList.querySelectorAll('input[type="checkbox"]').forEach(function (child) {
                    child.checked = checkbox.checked;
                });
            });
        }
    });
}

// ============================================
//  ВІДПРАВКА ФІЛЬТРІВ
// ============================================
function initFormListeners() {
    var form = document.getElementById('sidebar_tree');
    if (!form) return;

    form.querySelectorAll('input[type="checkbox"]').forEach(function (checkbox) {
        checkbox.addEventListener('change', function () {
            sendDataServer();
        });
    });
}

function sendDataServer(extraParams) {
    var form = document.getElementById('sidebar_tree');
    var params = $(form).serialize();
    if (extraParams) params += '&' + extraParams;

    $.ajax({
        type: 'GET',
        url: '/customer/products_content?' + params,
        dataType: 'script'
    });
}

// ============================================
//  КНОПКА СКИНУТИ ФІЛЬТР
// ============================================
function bindResetBtn() {
    var btn = document.getElementById('clear-categories-btn');
    if (!btn) return;

    // клонуємо щоб прибрати старі listeners
    var newBtn = btn.cloneNode(true);
    btn.parentNode.replaceChild(newBtn, btn);

    newBtn.addEventListener('click', function(e) {
        e.preventDefault();

        // 1. Знімаємо всі чекбокси в дереві
        document.querySelectorAll('#tree_id input[type="checkbox"]').forEach(function(cb) {
            cb.checked = false;
        });

        // 2. Відправляємо запит з параметром clear_categories=1
        sendDataServer('clear_categories=1');
    });
}

// ============================================
//  CLIENT SELECTOR
// ============================================
function initClientSelector() {
    var clientInput = document.getElementById('client_input');
    var clientIdField = document.getElementById('client_id');

    if (!clientInput || !clientIdField) return;

    // Прибираємо старий listener
    var newInput = clientInput.cloneNode(true);
    clientInput.parentNode.replaceChild(newInput, clientInput);

    newInput.addEventListener('input', function (e) {
        var datalist = document.getElementById('clients');
        var inputValue = e.target.value;
        var options = datalist.querySelectorAll('option');
        var selectedOption = null;

        for (var i = 0; i < options.length; i++) {
            if (options[i].value === inputValue) {
                selectedOption = options[i];
                break;
            }
        }

        if (selectedOption) {
            clientIdField.value = selectedOption.dataset.id;
            sendDataServer();
        } else {
            clientIdField.value = '';
        }
    });
}

function ClearClient() {
    var clientInput = document.getElementById('client_input');
    var clientIdField = document.getElementById('client_id');
    if (clientInput) clientInput.value = '';
    if (clientIdField) clientIdField.value = '';
    sendDataServer();
    return false;
}

// ============================================
//  ІНІЦІАЛІЗАЦІЯ — запускаємо на всі події
// ============================================
function initAll() {
    initTree();
    initCheckboxTree();
    initFormListeners();
    initClientSelector();
    bindResetBtn();
}

// DOMContentLoaded — перший запуск
document.addEventListener('DOMContentLoaded', initAll);

// turbo:load — після Turbo навігації
document.addEventListener('turbo:load', initAll);

// turbo:render — після часткового рендерингу (AJAX оновлення контенту)
document.addEventListener('turbo:render', initAll);


// ============================================
//  HAMBURGER — ховаємо під modal
// ============================================
document.addEventListener('DOMContentLoaded', function () {
    var hamburger = document.querySelector('.hamburger');
    if (!hamburger) return;

    // Коли будь-який modal відкривається
    document.addEventListener('show.bs.modal', function () {
        hamburger.classList.add('modal-open-hide');
    });

    // Коли modal закривається
    document.addEventListener('hide.bs.modal', function () {
        hamburger.classList.remove('modal-open-hide');
    });

    // Fallback — слідкуємо за класом modal-open на body
    var observer = new MutationObserver(function (mutations) {
        mutations.forEach(function (mutation) {
            if (mutation.attributeName === 'class') {
                if (document.body.classList.contains('modal-open')) {
                    hamburger.classList.add('modal-open-hide');
                } else {
                    hamburger.classList.remove('modal-open-hide');
                }
            }
        });
    });

    observer.observe(document.body, { attributes: true });
});