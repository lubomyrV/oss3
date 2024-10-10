@RestResource(urlMapping='/solarenergy/*')
global with sharing class SolarEnergyService {


    @HttpGet
    global static void getSolarEnergy() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        try {
            String solarEnergyId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
            List<Solar_Energy__c> energies = [
                SELECT Id, Name, Solar_Day__c, Power__c, Date_Time__c, Current__c, Voltage__c 
                FROM Solar_Energy__c 
                WHERE Id  = :solarEnergyId
            ];
            Solar_Energy__c solarEnergy;
            if (!energies.isEmpty()) {
                solarEnergy = energies.get(0);
            }
            // return solarEnergy;
            response.responseBody = Blob.valueOf(JSON.serialize(solarEnergy));
            response.statusCode = 200;
            // Integer i = 25 / 0;
        } catch (Exception e) {
            response.responseBody = Blob.valueOf(e.getMessage());
            response.statusCode = 500;
        }
        // return null;
    }

	@HttpPost
    global static String createEnergyRecord(String timestamp, String voltage, String current) {
        Map<String,Object> result = new Map<String,Object>();

        try {
            Datetime convertedTimestamp = Datetime.valueOf(timestamp.replace('T', ' '));
            System.debug(convertedTimestamp);
    
            Date currentDate = convertedTimestamp.date();
            List<Solar_Day__c> solarDays = [SELECT Id FROM Solar_Day__c WHERE Date__c  = :currentDate];
            System.debug(solarDays);
    
            Solar_Day__c currentSolarDay;
            if (solarDays.isEmpty()) {
                currentSolarDay = new Solar_Day__c(Date__c = currentDate);
                insert currentSolarDay;
            } else {
                currentSolarDay = solarDays.get(0);
            }
            System.debug(currentSolarDay);
            Solar_Energy__c energy = new Solar_Energy__c();
            energy.Date_Time__c = timestamp;
            energy.Solar_Day__c = currentSolarDay.Id;
            energy.Timestamp__c = convertedTimestamp;
            energy.Voltage__c = Double.valueOf(voltage);
            energy.Current__c = Double.valueOf(current);
            System.debug(energy);
            Database.SaveResult saveResult = Database.insert(energy, false);
            System.debug(saveResult);
            if (saveResult.isSuccess()) {
                result.put('Id', energy.Id);
                result.put('timestamp', timestamp);
                result.put('isSuccess', true);
            } else {
                result.put('isSuccess', false);
                result.put('Errors', saveResult.getErrors());
            }
            return JSON.serialize(result);
        } catch(Exception exp) {
            result.put('isSuccess', false);
            result.put('Errors', exp.getMessage());
            return JSON.serialize(result);
        }
    }
}