// https://github.com/kevinohara80/sfdc-trigger-framework
public virtual with sharing class TriggerHandler {

    protected virtual void validate(){}
    protected virtual void applyDefaults(){}
    protected virtual void beforeInsert(){}
    protected virtual void beforeUpdate(){}
    protected virtual void beforeDelete(){}
    protected virtual void afterInsert(){}
    protected virtual void afterUpdate(){}
    protected virtual void afterDelete(){}
    protected virtual void afterUndelete(){}

    public static void addBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.add(handlerName);
    }

    public static void removeBypass(String handlerName) {
        TriggerHandler.bypassedHandlers.remove(handlerName);
    }

    public static Boolean isBypassed(String handlerName) {
        return TriggerHandler.bypassedHandlers.contains(handlerName);
    }

    public static void clearAllBypasses() {
        TriggerHandler.bypassedHandlers.clear();
      }

    protected void run() {
        String handlerName = getHandlerName();
        if(!Trigger.isExecuting || Trigger.operationType == null) {
            throw new HandledException('Trigger handler called outside of Trigger execution: ' + handlerName);
        }

        if(TriggerHandler.bypassedHandlers.contains(handlerName)) {
            return;
        }

        switch on Trigger.operationType {
            when BEFORE_INSERT {
                this.applyDefaults();   
                this.beforeInsert();
            }
            when BEFORE_UPDATE {
                this.beforeUpdate();
            }
            when BEFORE_DELETE {
                this.beforeDelete();
            }
            when AFTER_INSERT {
                this.validate();
                this.afterInsert();
            }
            when AFTER_UPDATE {
                this.validate();
                this.afterUpdate();
            }
            when AFTER_DELETE {
                this.afterDelete();
            }
            when AFTER_UNDELETE {
                this.afterUndelete();
            }
        }
    }

    private static Set<String> bypassedHandlers = new Set<String>();

    private String getHandlerName() {
        return this.toString().substringBefore(':');
    }
}