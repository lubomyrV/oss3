public with sharing class FileManagerController implements IController{
    
    @AuraEnabled(cacheable=true)
    public static List<Seal__c> getSeals(Id recordId) {
        List<Seal__c> seals = new List<Seal__c>();
        try {
            List<ContentDocumentLink> contentDocumentLinks = [SELECT Id, ContentDocument.Id, ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId = :recordId];
            Set<Id> contentDocumentIds = new Set<Id>();
            for (ContentDocumentLink cdl : contentDocumentLinks) {
                contentDocumentIds.add(cdl.ContentDocument.Id);
            }
            seals = [
                SELECT Id, Content_Document_Name__c, Content_Document_Id__c, Hash__c, Is_Valid__c 
                FROM Seal__c 
                WHERE Content_Document_Id__c IN :contentDocumentIds
            ];
            contentDocumentIds.clear();
            for (Seal__c seal : seals) {
                contentDocumentIds.add(seal.Content_Document_Id__c);
            }
            if (seals.isEmpty() || contentDocumentLinks.size() > seals.size())  {
                List<Seal__c> newSeals = new List<Seal__c>();
                for (ContentDocumentLink cdl : contentDocumentLinks) {
                    if (!contentDocumentIds.contains(cdl.ContentDocument.Id)) {
                        newSeals.add(
                           new Seal__c(
                            Content_Document_Name__c = cdl.ContentDocument.Title,
                            Content_Document_Id__c = cdl.ContentDocument.Id
                           ) 
                        );
                    }
                }
                System.enqueueJob(new DmlAsyncUtility(newSeals, DmlAsyncUtility.DmlType.INSERT_TYPE));
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return seals;
    }

    @AuraEnabled
    public static List<Id> checkDocuments(List<Id> documentIds) {
        List<Seal__c> seals = new List<Seal__c>();
        try {
            seals = [
                SELECT Id, Content_Document_Name__c, Content_Document_Id__c, Hash__c, Is_Valid__c 
                FROM Seal__c 
                WHERE Id IN :documentIds
            ];

            Set<Id> contentDocumentIds = new Set<Id>();
            for (Seal__c seal : seals) {
                contentDocumentIds.add(seal.Content_Document_Id__c);
            }

            List<ContentVersion> contentVersions = [
                SELECT Id, ContentDocumentId, FileType, VersionData, Checksum 
                FROM ContentVersion
                WHERE ContentDocumentId IN :contentDocumentIds AND IsLatest = true
            ];
            Map<Id,Blob> versionDataByContentDocumentId = new Map<Id,Blob>();
            for (ContentVersion cv : contentVersions) {
                versionDataByContentDocumentId.put(cv.ContentDocumentId, cv.VersionData);
            }

            for (Seal__c seal : seals) {
                Blob data = versionDataByContentDocumentId.get(seal.Content_Document_Id__c);
                String newHash = EncodingUtil.base64Encode(Crypto.generateDigest('SHA3-512', data));
                seal.Is_Valid__c = (seal.Hash__c == newHash);
            }
            new DmlUtility().updateSobjects(seals);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return documentIds;
    }

    @AuraEnabled
    public static List<Id> sealDocuments(List<Id> documentIds) {
        List<Seal__c> seals = new List<Seal__c>();
        try {
            seals = [
                SELECT Id, Content_Document_Name__c, Content_Document_Id__c, Hash__c, Is_Valid__c 
                FROM Seal__c 
                WHERE Id IN :documentIds
            ];

            Set<Id> contentDocumentIds = new Set<Id>();
            for (Seal__c seal : seals) {
                contentDocumentIds.add(seal.Content_Document_Id__c);
            }

            List<ContentVersion> contentVersions = [
                SELECT Id, ContentDocumentId, FileType, VersionData, Checksum 
                FROM ContentVersion
                WHERE ContentDocumentId IN :contentDocumentIds
            ];
            Map<Id,Blob> versionDataByContentDocumentId = new Map<Id,Blob>();
            for (ContentVersion cv : contentVersions) {
                versionDataByContentDocumentId.put(cv.ContentDocumentId, cv.VersionData);
            }

            for (Seal__c seal : seals) {
                if (seal.Hash__c == null) {
                    Blob data = versionDataByContentDocumentId.get(seal.Content_Document_Id__c);
                    String hash = EncodingUtil.base64Encode(Crypto.generateDigest('SHA3-512', data));
                    seal.Hash__c = hash;
                }
            }
            new DmlUtility().updateSobjects(seals);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return documentIds;
    }
}