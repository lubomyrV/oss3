public interface IQueryBuilder {
    IQueryBuilder addField(String sobjectField);
    IQueryBuilder addField(Schema.SObjectField sobjectField);
    IQueryBuilder addFields(List<String> sobjectFields);
    IQueryBuilder addFields(List<Schema.SObjectField> sobjectFields);
    IQueryBuilder addCondition(String condition);
    String toSOQL();
}