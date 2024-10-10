({
	fireNow : function(component, event, helper) {
		let compEvent = component.getEvent("customeEvent");
       	compEvent.setParams({"data": "test data from demoAuraSecond.cmp"});
       	compEvent.fire();
	}
})