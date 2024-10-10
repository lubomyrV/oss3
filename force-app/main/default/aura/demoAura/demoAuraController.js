({
    init : function(component, event, helper) {
        let action1 = component.get("c.serverEchoOne");
        action1.setParams({ str : "test" });
        helper.apexCall(action1).then(
            response => {
                console.log('response one '+response);
                component.set("v.prom1", response);
                let action2 = component.get("c.serverEchoTwo");
                return helper.apexCall(action2);
            }
         ).then(
            response2 => {
                console.log('response two '+response2);
                component.set("v.prom2", response2);
                let action3 = component.get("c.serverEchoThree");
                return helper.apexCall(action3);
            }
        ).then(
            response3 => {
                console.log('response three '+response3);
                component.set("v.prom3", response3);
            }
        ).catch(
             error => {
                 console.error(error);
             }
        ).finally(
            ()=>{
                console.log('finally block');
            }
        );
    },
    
    handleCE : function(component, event) {
       let message = event.getParam("data");
       component.set("v.messageFromChildEvent", message);
   }
})