(function ($) {
    $.fn.selectInputBox = function (data, param) {

        if (typeof data == 'string') {
            return $.fn.selectInputBox.methods[data](this, param);
        }
        data = data || [
            {
                "text": "_text",
                controls: [
                    {
                        "controlType": "textbox",
                        "text": "_text",
                        "name": "_name",
                        "options": {}
                    }
                ]
            }
        ];
        return this.each(function () {
            var _combobox = $("<input style='margin-right: 10px'/>");
            var id = UUIDUtil.getUUID();
            _combobox.attr("id", id);
            var _selectInputBox = $(this);
            _selectInputBox.data("comboboxId", id);
            _selectInputBox.append(_combobox);
            _combobox.combobox({
                valueField: 'text',
                textField: 'text',
                data: data,
                onSelect: function (record) {
                    _select(record, _selectInputBox, _combobox);
                }
            });
        });
    };
    $.fn.selectInputBox.methods = {
        "getValue": function (jq, param) {
            var names = jq.data("names");
            var controlIds = jq.data("controlIds");
            var controlTypes = jq.data("controlTypes");
            if (!controlIds || !names || !controlTypes) {
                return undefined;
            }
            var values = {};
            for (var i = 0; i < controlIds.length; i++) {
                values[names[i]] = $("#" + controlIds[i])[controlTypes[i]]("getValue");
            }
            return values;
        },
        "clear": function (jq, param) {
            var controlIds = jq.data("controlIds");
            var controlTypes = jq.data("controlTypes");
            if (!controlIds || !controlTypes) {
                return;
            }
            for (var i = 0; i < controlIds.length; i++) {
                $("#" + controlIds[i])[controlTypes[i]]("clear");
            }
        }
    };
    function _select(record, _selectInputBox) {
        var i;
        if (_selectInputBox.data("clearFuns")) {
            for (i = 0; i < _selectInputBox.data("clearFuns").length; i++) {
                _selectInputBox.data("clearFuns")[i]();
            }
        }
        var controlIds = [];
        var controlTypes = [];
        var names = [];
        var clearFuns = [];

        for (i = 0; i < record.controls.length; i++) {
            var control = record.controls[i];
            var _span = $("<span style=\"padding:0 6px 0 6px  \">" + (control.text ? control.text : "") + "</span>");
            _selectInputBox.append(_span);
            var _input = $("<input />");
            var id = UUIDUtil.getUUID();
            _input.attr("id", id);
            _span.after(_input);
            _input[control.controlType](control.options);
            controlIds[i] = id;
            controlTypes[i] = control.controlType;
            names[i] = control.name;
            (function (_input, control, _span) {
                clearFuns[i] = function () {
                    _input[control.controlType]("destroy");
                    _span.remove();
                };
            })(_input, control, _span);

        }
        _selectInputBox.data("controlIds", controlIds);
        _selectInputBox.data("controlTypes", controlTypes);
        _selectInputBox.data("names", names);
        _selectInputBox.data("clearFuns", clearFuns);
    }
})(jQuery);