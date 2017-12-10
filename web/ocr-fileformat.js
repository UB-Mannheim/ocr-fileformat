var OcrFileformatAPI = function OcrFileformatAPI(endpoint) {
    this.endpoint = endpoint;
};

OcrFileformatAPI.prototype.urlFor = function urlFor(action, params) {
    params || (params = {});
    url = this.endpoint + '?do=' + action;
    for (var paramName of Object.keys(params)) {
        url += '&' + paramName + '=' + params[paramName];
    }
    return url;
};

OcrFileformatAPI.prototype.updateFormats = function updateFormats(cb) {
    var self = this;
    this.request('list', null, null, function(err, formats) {
        self.formats = formats;
        cb(err);
    });
};

OcrFileformatAPI.prototype.request = function request(endpoint, query, formData, cb) {
    ajaxCall = {
        type: 'GET',
        url: api.urlFor(endpoint, query),
        success: function(data) {
            cb(null, data);
        },
        error: function(xhr) {
            cb(xhr.responseText);
        },
    };
    if (formData) {
        ajaxCall.type = 'POST';
        ajaxCall.data = formData
        ajaxCall.processData =  false;
        ajaxCall.contentType = false;
    }
    $.ajax(ajaxCall);
};

function escapeHTML(str) {
    return str.
        replace(/&/g, '&amp;').
        replace(/</g, '&lt;').
        replace(/"/g, '&quot;').
        replace(/'/g, '&#39;').
        replace(/\//g, '&#x2F;').
        replace(/>/g, '&gt;');
}

function onChangeFormat() {
    if ($("#transform-from option").length == 1) {
        Object.keys(window.api.formats.transform).forEach(function(from) {
            $("#transform-from").append($("<option>").append(from));
        });
        $("#transform-from").removeAttr('disabled');
    }
    var selectedFrom = $("#transform-from").val();
    var selectedTo = $("#transform-to").val();
    $("#transform-to").attr('disabled', selectedFrom === null);
    if (selectedFrom) {
        $("#transform-to option").slice(1).remove();
        window.api.formats.transform[selectedFrom].forEach(function(to) {
            $("#transform-to").append($("<option>").append(to));
        });
    }
    if ($("#validate-format option").length == 1) {
        window.api.formats.validate.forEach(function(format) {
            $("#validate-format").append($("<option>").append(format));
        });
    }
}

function submit(tabName, params) {
    var pane = $("#" + tabName);
    var input = pane.find(".input .active input");
    if (input.attr('type') === 'file') {
        var formData = new FormData();
        formData.append('file', input.prop('files')[0]);
    } else {
        var url = input.val();
        params.url = url;
    }
    $("button .spinning", pane).removeClass('hidden');
    api.request(tabName, params, formData, function(err, data) {
        pane.find("button .spinning").addClass('hidden');
        if (err)
            return $.notify(err, 'error');
        if (url)  {
            pane.find(".result a.download").attr('href', url);
        }
        pane.find(".result pre code").html(escapeHTML(data));
        pane.find(".result").removeClass('hidden');
        Prism.highlightAll()
    });
}

function maybeEnableSubmit() {
    var el = $(".tab-pane.active")
    var inputSet = !!$(".input .active input", el).val();
    var selects = $(".formats select", el);
    var formatsSet = selects.length == selects.map(function() { return $(this).val(); }).length;
    $("button", el).attr('disabled', !(inputSet && formatsSet));
}

function hashRoute() {
    var hash = window.location.hash;
    var pageTab = hash.replace(/-.*/,'');
    $("a[data-toggle='tab'][href='" + pageTab + "']").tab('show');
    $("a[data-toggle='tab'][href='" + hash + "']").tab('show');
}

$(function() {
    $.notify.defaults({position: 'bottom right'});
    var api = window.api = new OcrFileformatAPI('ocr-fileformat.php');
    $.notify("Loading formats", 'info');
    api.updateFormats(function(err) {
        if (err) {
            $.notify("Error loading formats", "error");
            return;
        }
        $.notify("Loaded formats", 'success');

        $("#transform-from").on('change', onChangeFormat);

        $("a").on('shown.bs.tab', maybeEnableSubmit);
        $(":input").on('input change', maybeEnableSubmit);
        $(".tab-pane").on('shown.bs.tab', maybeEnableSubmit);

        $("#validate-submit").on('click', function() {
            submit('validate', {format: $("#validate-format").val()});
        });
        $("#transform-submit").on('click', function() {
            submit('transform', {from: $("#transform-from").val(), to: $("#transform-to").val() });
        });

        $("a[data-toggle='tab']").on('click tap', function() { window.location.hash = $(this).attr('href'); });

        $(window).on('hashchange', hashRoute);

        onChangeFormat();
        hashRoute();
    });
});
