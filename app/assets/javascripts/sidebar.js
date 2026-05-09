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
//  CLIENT PICKER MODAL
// ============================================
function initClientPicker() {
    var modal = document.getElementById('clientPickerModal');
    if (!modal) return;

    // Collapse all nested lists on init
    modal.querySelectorAll('.cpicker-folder > ul.cpicker-list').forEach(function(ul) {
        ul.style.display = 'none';
    });

    // Folder toggle — clone to clear stale listeners
    modal.querySelectorAll('.cpicker-folder-row').forEach(function(row) {
        var newRow = row.cloneNode(true);
        row.parentNode.replaceChild(newRow, row);
        newRow.addEventListener('click', function() {
            var li = newRow.closest('li.cpicker-folder');
            var sublist = li ? li.querySelector(':scope > ul.cpicker-list') : null;
            var caret = newRow.querySelector('.cpicker-caret');
            if (!sublist) return;
            var open = sublist.style.display === 'block';
            sublist.style.display = open ? 'none' : 'block';
            if (caret) caret.classList.toggle('cpicker-caret-open', !open);
        });
    });

    // Item selection — clone to clear stale listeners
    modal.querySelectorAll('.cpicker-item').forEach(function(item) {
        var newItem = item.cloneNode(true);
        item.parentNode.replaceChild(newItem, item);
        newItem.addEventListener('click', function() {
            var id   = newItem.dataset.id;
            var name = newItem.dataset.name;
            var idField = document.getElementById('client_id');
            var label   = document.getElementById('clientBtnLabel');
            if (idField) idField.value = id;
            if (label)  { label.textContent = name; label.classList.remove('is-placeholder'); }
            updateCartInfoClient(name);
            $(modal).modal('hide');
            sendDataServer();
        });
    });

    // Search
    var searchInput = document.getElementById('clientPickerSearch');
    if (searchInput) {
        var newSearch = searchInput.cloneNode(true);
        searchInput.parentNode.replaceChild(newSearch, searchInput);
        newSearch.addEventListener('input', function() {
            filterClientTree(this.value.trim().toLowerCase());
        });
    }

    // On open: clear search, highlight current selection
    $(modal).off('show.bs.modal.cpicker').on('show.bs.modal.cpicker', function() {
        var search = document.getElementById('clientPickerSearch');
        if (search) { search.value = ''; filterClientTree(''); }
        var currentId = (document.getElementById('client_id') || {}).value;
        modal.querySelectorAll('.cpicker-item').forEach(function(item) {
            item.classList.toggle('cpicker-item-selected', !!currentId && item.dataset.id == currentId);
        });
    });
}

function filterClientTree(query) {
    var container = document.getElementById('clientTreeContainer');
    if (!container) return;

    if (!query) {
        container.querySelectorAll('.cpicker-item, .cpicker-folder').forEach(function(el) { el.style.display = ''; });
        container.querySelectorAll('.cpicker-folder > ul.cpicker-list').forEach(function(ul) { ul.style.display = 'none'; });
        container.querySelectorAll('.cpicker-caret').forEach(function(c) { c.classList.remove('cpicker-caret-open'); });
        return;
    }

    container.querySelectorAll('.cpicker-item, .cpicker-folder').forEach(function(el) { el.style.display = 'none'; });
    container.querySelectorAll('ul.cpicker-list').forEach(function(ul) { ul.style.display = 'none'; });

    container.querySelectorAll('.cpicker-item').forEach(function(item) {
        if ((item.dataset.name || '').toLowerCase().indexOf(query) === -1) return;
        item.style.display = '';
        var node = item.parentElement;
        while (node && node !== container) {
            if (node.tagName === 'LI' && node.classList.contains('cpicker-folder')) node.style.display = '';
            if (node.tagName === 'UL') node.style.display = 'block';
            node = node.parentElement;
        }
    });
}

function ClearClient() {
    var idField = document.getElementById('client_id');
    var label   = document.getElementById('clientBtnLabel');
    if (idField) idField.value = '';
    if (label)   { label.textContent = 'Оберіть замовника...'; label.classList.add('is-placeholder'); }
    updateCartInfoClient(null);
    sendDataServer();
    return false;
}

function updateCartInfoClient(name) {
    var row  = document.getElementById('cart_info_client');
    var span = document.getElementById('cart_info_client_name');
    if (!row || !span) return;
    if (name) {
        span.textContent = name;
        row.style.display = '';
    } else {
        span.textContent = '';
        row.style.display = 'none';
    }
}

// ============================================
//  ІНІЦІАЛІЗАЦІЯ — запускаємо на всі події
// ============================================
function initAll() {
    initTree();
    initCheckboxTree();
    initFormListeners();
    initClientPicker();
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