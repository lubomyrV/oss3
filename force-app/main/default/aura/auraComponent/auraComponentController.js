({
	doInit : function(component, event, helper) {
		let recordId = component.get("v.recordId");
		console.log('aura doInit: '+recordId);
	},

	receiveLWCData : function(component, event, helper){
	    component.set("v.dataReceived", event.getParam("dataToSend"));
	}
})