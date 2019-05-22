({
	searchRecords : function(component,event,queryTerm) {
        var objectName = component.get("v.objectToSearchName");
		var action = component.get("c.getRecordsByName");
		var moreFields = component.get("v.moreFieldsToQuery");
        var selectedRecords = component.get("v.selectedRecordsResults");
		console.log('==moreFieldsToQuery=='+moreFields);
		$A.util.addClass(component.find("resultNotFound"), 'slds-hide');
        action.setParams({
            "objName" : objectName,
            "searchString" : queryTerm,
            "morefields" : moreFields,
            "selectedRecords" : selectedRecords
        });
        action.setCallback(this, function(response) {
            if (response.getState() == "SUCCESS") {
                var results = response.getReturnValue();
                if(results && results!==undefined && Object.keys(results).length>1) {
                    results = this.resultSort(results);
                    component.set("v.searchResults", results);
                } else {
                    //results not found
                    component.set("v.searchResults", results);
                    $A.util.removeClass(component.find("resultNotFound"), 'slds-hide');
                }
            }
            component.set('v.isSearching', false);
        });
         $A.enqueueAction(action);
	},
	uniqueArray : function(array) {
    var a = array.concat();
    for(var i=0; i<a.length; ++i) {
        for(var j=i+1; j<a.length; ++j) {
            if(a[i] === a[j])
                a.splice(j--, 1);
        }
    }

    return a;
	},
	resultSort : function(searchResults) {
        if(searchResults!==undefined && searchResults.length>1)
        {
            searchResults.sort(function(a, b)
            {
              if(a.Name !==undefined && b.Name !== undefined)
              {
                  var x = a.Name.toLowerCase();
                  var y = b.Name.toLowerCase();
                  if (x < y) {return -1;}
                  if (x > y) {return 1;}
                  return 0;
              }
              
            });
        }
	    
        return searchResults;
	}
})