public abstract inherited sharing class SObjectSelector {
    abstract Schema.SObjectType getSObjectType();
    abstract List<Schema.SObjectField> getSObjectFieldList();
    public QueryBuilder getQueryBuilder() {
        return new QueryBuilder(this.getSObjectType());
    }
    public virtual List<SObject> getRecordsById(Set<Id> idSet) {
        String query = this.getQueryBuilder().addFields(this.getSObjectFieldList()).addCondition(' WHERE Id IN :idSet').toSOQL();
        return Database.query(query);
    }

    public inherited sharing class QueryBuilder implements IQueryBuilder{
        public QueryBuilder(Schema.SObjectType sobjectType) {
            this.sobjectType = sobjectType;
        }
        private Schema.SObjectType sobjectType;
        private String condition;
        private Set<String> fieldSet = new Set<String>();
        private List<Schema.SObjectField> sobjectFields = new List<Schema.SObjectField>();
    
        public QueryBuilder addField(String sobjectField) {
            this.fieldSet.add(sobjectField);
            return this;
        }
        public QueryBuilder addField(Schema.SObjectField sobjectField) {
            this.sobjectFields.add(sobjectField);
            return this;
        }
        public QueryBuilder addFields(List<String> sobjectFields) {
            this.fieldSet.addAll(sobjectFields);
            return this;
        }
        public QueryBuilder addFields(List<Schema.SObjectField> sobjectFields) {
            this.sobjectFields.addAll(sobjectFields);
            return this;
        }
        public QueryBuilder addCondition(String condition) {
            this.condition = condition;
            return this;
        }
        public String toSOQL(){
            for (Schema.SObjectField sobjectField : sobjectFields) {
                fieldSet.add(sobjectField.getDescribe().getName());
            }
            String fields = String.join(fieldSet, ', ').removeEnd(', ');
            String query = 'SELECT ' + fields + ' FROM ' + this.sobjectType.toString() + ' ' + this.condition;
            System.debug(query);
            return query;
        }
    }
}