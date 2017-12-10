/* globals $ */

let OcrFileformatAPI = function OcrFileformatAPI(endpoint) {
    this.endpoint = endpoint;
};

OcrFileformatAPI.prototype.urlFor = function urlFor(action, params) {
    params || (params = {});
    let url = this.endpoint + '?do=' + action;
    for (let paramName of Object.keys(params)) {
        url += '&' + paramName + '=' + params[paramName];
    }
    return url;
};

OcrFileformatAPI.prototype.updateFormats = function updateFormats(cb) {
    let self = this;
    this.request('list', null, null, function(err, formats) {
        self.formats = formats;
        cb(err);
    });
};

OcrFileformatAPI.prototype.request = function request(endpoint, query, formData, cb) {
    let ajaxCall = {
        type: 'GET',
        url: window.api.urlFor(endpoint, query),
        success: function(data) {
            cb(null, data);
        },
        error: function(xhr) {
            cb(xhr.responseText);
        },
    };
    if (formData) {
        ajaxCall.type = 'POST';
        ajaxCall.data = formData;
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
    let selectedFrom = $("#transform-from").val();
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
    let pane = $("#" + tabName);
    let input = pane.find(".input .active input");
    let formData;
    const isFileUpload = input.attr('type') === 'file';
    if (isFileUpload) {
        formData = new FormData();
        formData.append('file', input.prop('files')[0]);
    } else {
        params.url = input.val();
    }
    $("button .spinning", pane).removeClass('hidden');
    window.api.request(tabName, params, formData, function(err, data) {
        pane.find("button .spinning").addClass('hidden');
        if (err) {
            return $.notify(err, 'error');
        }
        const resultDataContainer = pane.find('.result pre code');
        const outputFormat = $("#transform-to").val();
        if (isFileUpload) {
            const basename = input.val().replace(/.*\\/, ''); // C:\fakepath\bla.foo -> bla.foo
            const extension = outputFormat === 'text' ? 'text'
                : outputFormat === 'hocr' ? 'html'
                : outputFormat + '.xml';
            pane.find(".result a.download")
                .attr('download', `${basename}.${extension}`)
                .attr('href', `data:text/plain;charset=utf-8,${encodeURIComponent(data)}`);
        } else {
            pane.find(".result a.download").attr('href', input.val());
        }
        resultDataContainer.html(escapeHTML(data));
        pane.find(".result").removeClass('hidden');
        /* global Prism*/
        Prism.highlightAll();
    });
}

function maybeEnableSubmit() {
    let el = $(".tab-pane.active");
    let inputSet = !!$(".input .active input", el).val();
    let selects = $(".formats select", el);
    let formatsSet = selects.length == selects.map(function() { return $(this).val(); }).length;
    $("button", el).attr('disabled', !(inputSet && formatsSet));
}

function hashRoute() {
    let hash = window.location.hash;
    let pageTab = hash.replace(/-.*/, '');
    $("a[data-toggle='tab'][href='" + pageTab + "']").tab('show');
    $("a[data-toggle='tab'][href='" + hash + "']").tab('show');
}

$(function() {
    $.notify.defaults({position: 'bottom right'});
    const api = window.api = new OcrFileformatAPI('ocr-fileformat.php');
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

/* vim: set sw=4 : */
