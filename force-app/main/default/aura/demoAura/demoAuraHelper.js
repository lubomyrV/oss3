({
    apexCall : function(action) {
        return new Promise(function(resolve, reject) { 
            action.setCallback(
                this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        console.log(response.getReturnValue());
                        resolve(response.getReturnValue());
                    } else {
                        reject(new Error(response.getError()));
                    }
                }); 
            $A.enqueueAction(action);
        });
    },
})