  
  
  var KoAjaxTableVM = (function () {
    function KoAjaxTableVM(params) {
        var _this = this;
        // Output parameters
        this.collapsable = ko.observable(false);
        this.collapse = ko.observable(false);
        this.expandedOnce = ko.observable(false);
        this.title = ko.observable(" items");
        this.titleCount = ko.observable(true);
        this.columns = ko.observableArray([]);
        this.columnNames = ko.observableArray([]);
        this.filterColumns = ko.observableArray([]);
        this.filters = ko.observableArray([]);
        this.selectedFilter = ko.observable("");
        this.links = null;
        this.filter = null;
        // Output processing
        this.url = ko.observable("");
        this.searchTerm = ko.observable("").extend({ rateLimit: 250 });
        this.pageSize = ko.observable(10);
        this.currentPage = ko.observable(0);
        this.maximumPage = ko.pureComputed(function () {
            return Math.ceil(_this.filteredItems().length / _this.pageSize());
        });
        this.displayFrom = ko.pureComputed(function () {
            return (_this.currentPage() * _this.pageSize() + 1);
        });
        this.displayTo = ko.pureComputed(function () {
            return Math.min((_this.currentPage() + 1) * _this.pageSize(), _this.filteredItems().length);
        });
        this.fromToMessage = ko.pureComputed(function () {
            var message = "No entries found!";
            if (_this.filteredItems().length > 0) {
                message = "Showing " + _this.displayFrom() + " to " + _this.displayTo() + " of " + _this.filteredItems().length + " items.";
                if (_this.filteredItems().length != _this.items().length)
                    message += " (" + _this.items().length + " total)";
            }
            return message;
        });
        // All Data
        this.items = ko.observableArray([]).extend({ rateLimit: { timeout: 50, method: "notifyWhenChangesStop" } });
        this.filteredItems = ko.pureComputed(function () {
            var result;
            if ((_this.searchTerm() != null && _this.searchTerm() != "") || (_this.filterColumns().length > 0 && _this.selectedFilter() != null && _this.selectedFilter() != ""))
                result = _this.items().filter(function (e) {
                    return ko.toJSON(e).toLowerCase().indexOf(_this.searchTerm().toLowerCase()) > -1 && _this.filterMatches(e);
                });
            else
                result = _this.items();
            return result;
        });
        this.currentPageItems = ko.computed(function () {
            return _this.filteredItems().slice(_this.currentPage() * _this.pageSize(), (_this.currentPage() + 1) * _this.pageSize());
        });
        // The values in the columns that must be filtered
        this.filterColumnValues = ko.computed(function () {
            var model = _this;
            var values = Array();
            if (model.filterColumns().length > 0) {
                // Instantiate column value lists
                model.filterColumns().each(function (column) {
                    values[column] = [];
                });
                // Get the distinct values for each column
                model.items().each(function (item) {
                    model.filterColumns().each(function (column) {
                        var value = item[column];
                        var valueList = values[column];
                        if (valueList.indexOf(value) == -1) {
                            values[column].add(value);
                        }
                    });
                });
            }
            return values;
        });
		
        this.getItems = function () {
            var model = _this;
			var json = {};
			json['status'] = 'success';
			json['data'] = [];

			var temp = [];	
			var cnt = 0;
			data = $.parseJSON($.ajax({  
								type: "GET",  
								url: "http://196.216.167.210:7483/api/sightings",  
								dataType: "json",
								async: false	
								}).responseText);			
			
			for(i = 0; i < data.length; i++){
								
				if(jQuery.inArray(data[i].keyword, temp) == -1)  {
							
					var sum = 0;
					for(var j=0, len=data.length; j<len; j++){
						if(data[j]['keyword'] == data[i].keyword)
						  sum += 1
					}
						
					cnt = cnt + 1;
					
					var sight = {
								"num": cnt,
								"keyword": data[i].keyword,
								"cnt": sum
							}
							
					json['data'].push(sight);
										
					model.populateTable(json['data']);	
					
					temp.push(data[i].keyword);
				}				
			}
			
        };
        this.populateTable = function (data) {
            var model = _this;
            model.items([]);
            if (model.filter != null) {
                data = ko.utils.arrayFilter(data, model.filter);
            }
            model.items.pushAll(data);
        };
        this.updateFilter = function (columnName, value) {
            _this.selectedFilter(columnName);
            _this.filters[columnName] = value;
            _this.selectedFilter.notifySubscribers();
            console.log("notifySubscribers " + columnName + " " + value);
        };
        this.filterMatches = function (e) {
            var result = true;
            var model = _this;
            if (model.filters) {
                if (model.filterColumns().length > 0) {
                    // Instantiate column value lists
                    model.filterColumns().each(function (column) {
                        if (result) {
                            if (model.filters[column] != "" && typeof model.filters[column] != "undefined") {
                                result = model.filters[column] == e[column];
                            }
                        }
                    });
                }
            }
            return result;
        };
        // Save state
        this.saveSearchState = function () {
            console.log("Save state");
            //localStorage.setItem(document.URL + '-currentPage', this.currentPage().toString());
            //localStorage.setItem(document.URL + '-pageSize', this.pageSize().toString());
            //localStorage.setItem(document.URL + '-searchTerm', this.searchTerm().toString());
            //localStorage.setItem(document.URL + '-filters', this.filters().toString());
        };
        // Load state
        this.loadSearchState = function () {
            console.log("Load state");
            //this.currentPage(localStorage.getItem(document.URL + '-currentPage'))
            //this.pageSize(localStorage.getItem(document.URL + '-pageSize'))
            //this.searchTerm(localStorage.getItem(document.URL + '-searchTerm'))
            //this.filters(localStorage.getItem(document.URL + '-filters'))
        };
        if (params.title != null)
            this.title(params.title);
        this.url(params.url);
        this.columns(params.columns);
        this.columnNames(params.columnNames);
        this.links = params.links;
        this.filter = params.filter;
        if (params.collapse == 'true' || params.collapse == 'false' || params.collapse == true || params.collapse == false) {
            this.collapse(params.collapse);
        }
        if (this.collapse()) {
            var collapseSubscribtion = this.collapse.subscribe(function (newvalue) {
                _this.expandedOnce(true);
                collapseSubscribtion.dispose();
            });
        }
        else {
            this.expandedOnce(true);
        }
        this.getItems();
        // 
        if (params.filterColumns != null) {
            this.filterColumns(params.filterColumns);
        }
        var model = this;
        model.saveSearchState();
        this.loadSearchState();
    }
    return KoAjaxTableVM;
})();
ko.components.register('ko-ajax-table', {
    viewModel: KoAjaxTableVM,
    template: '<h3>\
        <!-- ko if: collapsable -->\
        <i data-bind="click: function () {collapse(!collapse())}">\
            <i class="fa fa-minus-square" data-bind="visible: !collapse()"></i>\
            <i class="fa fa-plus-square" data-bind="visible: collapse"></i>\
        </i>\
        <!-- /ko -->\
        <!-- ko if: titleCount -->\
        <span data-bind="text: items().length"></span>\
        <!-- /ko -->\
        <span data-bind="text: title ? title : \' items\'"></span>\
    </h3>\
    <!-- ko if: expandedOnce -->\
    <div id="overriddenTable" class="row" data-bind="visible: !collapse()">\
        <div class="form-inline">\
            <div class="col-md-6">\
            </div>\
            <div class="col-md-6 text-right">\
                <label class="control-label" for="tableSearch">Search&nbsp;</label><input id="tableSearch" class="form-control" data-bind="textInput: searchTerm"/>\
            </div>\
        </div>\
        <div class="col-md-12">\
            <table class="table">\
                <thead>\
                    <tr>\
                        <!-- ko if: links!=null && typeof(links) != null -->\
                        <th></th>\
                        <!-- /ko -->\
                        <!-- ko foreach: columnNames -->\
                            <th><span data-bind="text: $data"></span>\
                                <!-- ko if: $parent.filterColumns().indexOf($data) > -1 && $parent.filterColumnValues()[$data].length > 1 -->\
                                <select class="" data-bind="optionsCaption: \'All\', options: $parent.filterColumnValues()[$data], event: { change: function() { $parent.updateFilter($data, $element.value) } }">\
                                </select>\
                                <!-- /ko -->\
                            </th>\
                        <!-- /ko -->\
                    </tr>\
                </thead>\
                <tbody data-bind="foreach: currentPageItems">\
                    <tr>\
                        <!-- ko if: $parent.links!=null && typeof($parent.links) != null -->\
                        <td data-bind="html: $parent.links($data)"></td>\
                        <!-- /ko -->\
                        <!-- ko foreach: $parent.columns -->\
                        <td data-bind="text: $parent[$data]"></td>\
                        <!-- /ko -->\
                    </tr>\
                </tbody>\
            </table>\
        </div>\
        <div>\
            <div class="col-md-6" data-bind="text: fromToMessage"></div>\
            <div class="col-md-6 text-right">\
                <span class="btn-group">\
                    <button class="btn btn-default" data-bind="enable: currentPage() > 0, click: currentPage(currentPage()-1)"> Previous </button>\
                    <span class="btn btn-default disabled" data-bind = "text: currentPage() + 1" ></span>\
                    <button class="btn btn-default" data-bind = "enable: filteredItems().length > (currentPage()+1) * pageSize(), click: currentPage(currentPage()+1)"> Next </button>\
                </span>\
            </div>\
        </div>\
        <br/>\
    </div>\
    <!-- /ko -->'
});
//# sourceMappingURL=KoAjaxTable.js.map