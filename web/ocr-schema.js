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
        url: 'ocr-schema.php?do=list',
        type: 'GET',
        dataType: 'json',
        contentType: 'application/json',
        success: function(data) {
            var source = {};
            var target = {};
            data.transform.forEach(function(t) {
                t.replace(/(.*)__(.*)/, function(_, from, to) {
                    if (!source[from])
                        $("#transform-from").append($("<option>").append(from));
                    source[from] = true;
                    if (!target[to])
                        $("#transform-to").append($("<option>").append(to));
                    target[to] = true;
                });
            });
            for (var i = 0 ;i < data.validate.length; i++) {
                $("#validate-schema").append($("<option>").append(data.validate[i]));
            }
        },
    });
}
function handleClick(tabName, params) {
    var url = $("#" + tabName + "-url").val().trim();
    if (!url) { return; }
    $("#" + tabName + "-submit .spinning").removeClass('hidden');
    $.ajax({
        type: 'GET',
        url: 'ocr-schema.php?do=' + tabName + '&' + params + "&url=" + url,
        success: function(data) {
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
                    'schema=' + $("#validate-schema").val());
    });
    $("#transform-submit").on('click', function() {
        handleClick('transform',
                 'from=' + $("#transform-from").val() + '&' +
                   'to=' + $("#transform-to").val());
    });
});
