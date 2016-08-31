var ENDPOINT = 'ocr-fileformat.php';

function escapeHTML(str) {
    return str.
        replace(/&/g, '&amp;').
        replace(/</g, '&lt;').
        replace(/"/g, '&quot;').
        replace(/'/g, '&#39;').
        replace(/\//g, '&#x2F').
        replace(/>/g, '&gt;');
}

function updateOptions() {
    $.ajax({
        url: ENDPOINT + '?do=list',
        type: 'GET',
        dataType: 'json',
        contentType: 'application/json',
        success: function(data) {
            var target = {};
            Object.keys(data.transform).forEach(function(from) {
                $("#transform-from").append($("<option>").append(from));
                data.transform[from].forEach(function(to) {
                    if (!target[to])
                        $("#transform-to").append($("<option>").append(to));
                    target[to] = true;
                });
            });
            data.validate.forEach(function(format) {
                $("#validate-format").append($("<option>").append(format));
            })
        },
    });
}

function handleClick(tabName, params) {
    var url = $("#" + tabName + "-url").val().trim();
    if (!url) { return; }
    $("#" + tabName + "-submit .spinning").removeClass('hidden');
    $.ajax({
        type: 'GET',
        url: ENDPOINT + '?do=' + tabName + '&' + params + "&url=" + url,
        success: function(data) {
            $("#" + tabName + "-result a.download").attr('href', url);
            $("#" + tabName + "-result pre code").html(escapeHTML(data));
            $("#" + tabName + "-submit .spinning").addClass('hidden');
            $("#" + tabName + "-result").removeClass('hidden');
            Prism.highlightAll()
        },
        error: function(xhr) {
            notie.alert(3, xhr.responseText, 5);
            $("#" + tabName + "-submit .spinning").addClass('hidden');
        },
    });
}

$(function() {
    updateOptions();
    $("#validate-submit").on('click', function() {
        handleClick('validate',
                    'format=' + $("#validate-format").val());
    });
    $("#transform-submit").on('click', function() {
        handleClick('transform',
                 'from=' + $("#transform-from").val() + '&' +
                   'to=' + $("#transform-to").val());
    });
});
