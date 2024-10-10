public with sharing class DmlUtility {

    public List<SObject> insertSobjects(List<SObject> sobjects) {
        try {
            insert sobjects;
        } catch (DmlException exp) {
            throw exp;
        }
        return sobjects;
    }

    public List<Database.SaveResult> insertSobjects(List<SObject> sobjects, Boolean allOrNothing) {
        List<Database.SaveResult> saveResults = Database.insert(sobjects, allOrNothing);
        return saveResults;
    }

    public List<SObject> updateSobjects(List<SObject> sobjects) {
        try {
            update sobjects;
        } catch (DmlException exp) {
            throw exp;
        }
        return sobjects;
    }

    public List<Database.SaveResult> updateSobjects(List<SObject> sobjects, Boolean allOrNothing) {
        List<Database.SaveResult> saveResults = Database.update(sobjects, allOrNothing);
        return saveResults;
    }

    public List<SObject> deleteSobjects(List<SObject> sobjects) {
        try {
            delete sobjects;
        } catch (DmlException exp) {
            throw exp;
        }
        return sobjects;
    }

    public List<Database.DeleteResult> deleteSobjects(List<SObject> sobjects, Boolean allOrNothing) {
        List<Database.DeleteResult> deleteResults = Database.delete(sobjects, allOrNothing);
        return deleteResults;
    }
}