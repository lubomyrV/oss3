public virtual with sharing class SObjectDomain extends TriggerHandler implements IDomain {

    protected List<SObject> records {
		get {
			return Trigger.new;
		}
	}

	protected Map<Id, SObject> existingRecords {
		get {
            return Trigger.oldMap;
		}
	}

    public void triggerHandler() {
        this.run();
    }

}