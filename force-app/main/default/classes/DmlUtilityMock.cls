//https://github.com/surajp/universalmock
@isTest
public with sharing class DmlUtilityMock implements StubProvider{
    List<SObject> sobjects;
    public DmlUtilityMock(List<SObject> sobjects) {
        this.sobjects = sobjects;
    }

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName, 
        Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, 
        List<Object> listOfArgs) {
        if(stubbedMethodName == 'updateSobjects'){
            return sobjects;
        }
        return null;
    }
}