({
    handleSearch: function (component, event, helper) {
        var isEnterKey = event.keyCode === 13;
        var queryTerm = component.find('enter-search').get('v.value');
        if (isEnterKey) {
            component.set('v.isSearching', true);
            //call to server to bring searched components
            helper.searchRecords(component,event,queryTerm);
        }
    },
    doInit: function(component, event, helper) {
    },
    onRowSelection : function(component, event, helper) {
        var isSettingValueExplicitly = component.get("v.setValueExplicit");
        var selectedRows = event.getParam('selectedRows');
        //console.log('selectedRows' + JSON.stringify(selectedRows));
        //component.set("v.selectedRecords",selectedRows);
        var selecteRecordResults = component.get("v.selectedRecordsResults");
        selecteRecordResults = helper.uniqueArray(selecteRecordResults.concat(selectedRows));
        component.set("v.selectedRecordsResults",selecteRecordResults);
        var setSelectedRecordResults = new Set(selecteRecordResults);
        //remove the selected records from search list
        var searchResults = component.get("v.searchResults");
        var filteredResults = searchResults.filter(function(value, index, arr){
            return !setSelectedRecordResults.has(value);
        });
        component.set("v.searchResults",filteredResults);
        if( isSettingValueExplicitly===true)
        {
            var parent = component.get("v.parent");
            parent.parentMethod(selectedRows);
        }
    },
    resetAll : function(component,event,helper) {
        component.set("v.searchResults",[]);
        component.set("v.selectedRecords",[]);
        component.set("v.selectedRecordsResults",[]);
        component.find('enter-search').set('v.value','');
        
    },
    setValueSelectedRecords : function(component,event,helper)
    {
        var params = event.getParam("arguments");
        console.log('--newselectedRecords--'+JSON.stringify(params.newSelectedRecords));
        var selectedRows = params.newSelectedRecords;
        var recordsToAdd = params.recordsToAddBack;
        var selectedRowIds = [];
        var selectedRowsResults = [];
        //component.find("dataTableDisplay").set("v.selectedRows",selectedRowIds);
        for(var key in selectedRows)
        {
            selectedRowIds.push(selectedRows[key].Id);
            selectedRowsResults.push(selectedRows[key]);
        }
        //component.find("dataTableDisplay").set("v.selectedRows",selectedRowIds);
        component.set("v.selectedRecordsResults", selectedRowsResults);
        console.log('--recordsToAdd--'+JSON.stringify(params.recordsToAddBack));
        if(recordsToAdd)
        {
            var searchResults = component.get("v.searchResults");
            for (var key in recordsToAdd)
            {
                searchResults.push(recordsToAdd[key]);
            }
            searchResults = helper.resultSort(searchResults);
            console.log('--adding back searchResults--');
            component.set("v.searchResults",searchResults);
        }
        //dataTable.set("v.selectedRows",params.newSelectedRecords);
    },
    handleRemove : function(component,event,helper)
    {
        var recordId = event.getSource().get("v.name");
        //console.log("--pillId--"+recordId);
        var selectedRecordsResults = component.get("v.selectedRecordsResults");
        var searchResults = component.get("v.searchResults");
        selectedRecordsResults = selectedRecordsResults.filter(function( obj ) {
            if(obj.Id===recordId)
                searchResults.push(obj);
            return obj.Id !== recordId;
        });
        component.set("v.selectedRecordsResults",selectedRecordsResults);
        searchResults = helper.resultSort(searchResults);
        component.set("v.searchResults", searchResults);
        
    },
    removeAll : function(component,event,helper) {
        var selectedRecordsResults = component.get("v.selectedRecordsResults");
        var searchResults = component.get("v.searchResults");
        for(var key in selectedRecordsResults) {
            searchResults.push(selectedRecordsResults[key]);
        }
        component.set("v.selectedRecordsResults",[]);
        searchResults = helper.resultSort(searchResults);
        component.set("v.searchResults", searchResults);
    }
    
})