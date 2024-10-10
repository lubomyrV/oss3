({
	decrypt : function(component) {
		component.set("v.isLoading", true);
        let action = component.get("c.decryptData");
        action.setParams({ recordId : component.get("v.recordId") });
 
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
				//console.log(JSON.stringify(response.getReturnValue()));
				let data = response.getReturnValue();
				if (data){
					component.set("v.recordData", response.getReturnValue());
				} else {
					this.showMessage("Not valid", "Data is not valid and cannot be decrypted!", "warning");
				}
				component.set("v.isLoading", false);
            } else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
				component.set("v.isLoading", false);
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
					console.error(JSON.stringify(errors));
					this.showMessage("Error", "Something went wrong, please contact a system admin!", "error");
                } else {
                    console.error("Unknown error");
                }
				component.set("v.isLoading", false);
            }
        });
        $A.enqueueAction(action);
	},

	verification : function(component) {
		component.set("v.isLoading", true);
        let action = component.get("c.verifyHash");
        action.setParams({ recordId : component.get("v.recordId") });
 
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
				//console.log(JSON.stringify(response.getReturnValue()));
				if (response.getReturnValue()){
					this.showMessage("Valid", "Data is verified and valid.", "success");
				} else {
					this.showMessage("Not valid", "Data is not valid!", "warning");
				}
				component.set("v.isLoading", false);
            } else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
				component.set("v.isLoading", false);
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
					console.error(JSON.stringify(errors));
					this.showMessage("Error", "Something went wrong, please contact a system admin!", "error");
                } else {
                    console.error("Unknown error");
                }
				component.set("v.isLoading", false);
            }
        });
        $A.enqueueAction(action);
	},

	getInitData : function(component) {
		component.set("v.isLoading", true);
        let action = component.get("c.init");
        action.setParams({ recordId : component.get("v.recordId") });
 
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
				let initResult = response.getReturnValue();
				let dataMap = JSON.parse(initResult);
				//console.log(dataMap);
				component.set("v.hasEncryption", dataMap.hasEncryprion == "true");
				component.set("v.hasPermission", dataMap.hasPermission == "true");
				component.set("v.hasData", dataMap.hasData == "true");
				component.set("v.isLoading", false);
            } else if (state === "INCOMPLETE") {
                console.log("INCOMPLETE");
				component.set("v.isLoading", false);
            } else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
					console.error(JSON.stringify(errors));
					this.showMessage("Error", "Something went wrong, please contact a system admin!", "error");
                } else {
                    console.error("Unknown error");
                }
				component.set("v.isLoading", false);
            }
        });
        $A.enqueueAction(action);
	},

	showMessage : function(title, message, type) {
		$A.get("e.force:showToast").setParams({
			"title": title,
			"message": message,
			"type": type
		}).fire();
	}
})