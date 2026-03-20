function sendDataCartServer(data_type, form) {
    if (!form) {
        console.error('Form not found');
        return;
    }

    var formData = new FormData(form);
    formData.append('data_type', data_type);  // Додаємо data_type до форми

    Rails.ajax({
        type: 'PUT',
        url: form.action,
        data:formData,
        dataType: "json"
    });
}

function lineItemFieldOnChange() {
    // На мобільному активна форма cartFormMobile, на десктопі — cartForm
    var form = document.getElementById('cartFormMobile');
    if (!form || form.offsetParent === null) {
        // offsetParent === null означає що елемент прихований (display:none)
        form = document.getElementById('cartForm');
    }
    if (form) {
        sendDataCartServer("line_items", form);
    }
}

function boxDisable() {
    var form = document.getElementById('cartFormHeader');
    if (form) {
        sendDataCartServer("header", form);
    }
}