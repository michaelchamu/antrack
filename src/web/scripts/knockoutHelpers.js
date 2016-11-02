//ko.observableArray.fn.find = function (prop, data) {
//    var valueToMatch = data[prop];
//    return ko.utils.arrayFirst(this(), function (item: any) {
//        return item[prop] === valueToMatch;
//    });
//};
ko.observableArray.fn.firstWith = function (predicateCallback) {
    return ko.utils.arrayFirst(this(), predicateCallback);
};

ko.observableArray.fn.pushAllMapped = function (valuesToPush, fn) {
    var underlyingArray = this();

    this.valueWillMutate();

    var mappedData = ko.utils.arrayMap(valuesToPush, fn);
    ko.utils.arrayPushAll(underlyingArray, mappedData);

    this.valueHasMutated();

    return this;
};

ko.observableArray.fn.pushAll = function (valuesToPush) {
    var underlyingArray = this();

    this.valueWillMutate();
    ko.utils.arrayPushAll(underlyingArray, valuesToPush);
    this.valueHasMutated();

    return this;
};

// Helpers for select2 dropdowns
// For select 2, sets the id and text to the bound element val()
// Must be used to get the selected value with input and knockout observable array
function initVal(element, callback) {
    var data = { id: element.val(), text: element.val() };
    callback(data);
}

//e.g statusesQuery = (query) => koQuery(this.statuses(), query)
function koQuery(array, query) {
    var data = [];

    var exactMatch = false;
    ko.utils.arrayForEach(array, function (status) {
        if (query.term) {
            if (status.text.search(new RegExp(query.term, 'i')) >= 0)
                data.push(status);

            if (status.text.toLowerCase() === query.term.toLowerCase() && !exactMatch)
                exactMatch = true;
        } else
            data.push(status);
    });

    query.callback({
        results: data
    });
}

ko.observableArray.fn.query = function (query) {
    var underlyingArray = this();
    var data = [];

    var exactMatch = false;
    ko.utils.arrayForEach(underlyingArray, function (status) {
        if (query.term) {
            if (status.text.search(new RegExp(query.term, 'i')) >= 0)
                data.push(status);

            if (status.text.toLowerCase() === query.term.toLowerCase() && !exactMatch)
                exactMatch = true;
        } else
            data.push(status);
    });

    query.callback({
        results: data
    });
};
//# sourceMappingURL=knockoutHelpers.js.map
