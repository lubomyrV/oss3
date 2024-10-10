trigger AccountTrigger on Account (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    if( !(Trigger_Settings__c.getInstance()).Disable_AccountTrigger__c) {
        new AccountDomain().triggerHandler();
    } else {
        System.debug('The '+ String.valueOf(this).substring(0,String.valueOf(this).indexOf(':')) +' is disabled in Custom Settings');
    }
}