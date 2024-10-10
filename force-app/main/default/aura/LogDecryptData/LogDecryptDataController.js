({
	doInit : function(component, event, helper) {
		helper.getInitData(component);
	},

	handleVerification : function(component, event, helper) {
		helper.verification(component);
	},

	handleDecryptData : function(component, event, helper) {
		helper.decrypt(component);
	},
})