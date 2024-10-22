/**
 * Selector Layer 
 * The selector layer is home to all queries for a given object. 
 * This encourages reuse of queries and builds a central place for adjusting the fields used from the object.
 */
public interface ISelector {
    IQueryBuilder getQueryBuilder();
    List<SObject> getRecordsById(Set<Id> idSet);
}