// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

new CryptoUtil.CryptoExample().test();


List<Account> accList = (List<Account>)new AccountSelector().getRecordsById(new Set<Id>{'0010900000CuGYFAA3'});
System.debug('accList ' + accList);

List<Account> accList = (List<Account>)new AccountSelector().getAccountsByName('Dickenson plc');
System.debug('accList ' + accList);

System.debug(AccountService.newInstance().doSomething('Dickenson plc'));

new ScheduledMppt().execute(null);

new OopDemo().run();

DemoClass.method1();

Database.executeBatch(new BatchableExample());

HttpRequest req = new HttpRequest();
req.setEndpoint('callout:dummyjson' + '/auth/login');
req.setMethod('POST');
req.setHeader('Content-Type', 'application/json');
String body = JSON.serialize(new Map<String, String>{'username' => '{!$Credential.Username}', 'password' => '{!$Credential.Password}'});
System.debug('body ' + body);
req.setBody(body);
HttpResponse res = new Http().send(req);
System.debug('getStatus 1 ' + res.getStatus());
System.debug('getStatusCode 1 ' + res.getStatusCode());
System.debug('getBody 1 ' + res.getBody());
Map<String, Object> bodyMap = (Map<String, Object>)JSON.deserializeUntyped(res.getBody());
String token = (String)bodyMap.get('token');
System.debug('token ' + token);

HttpRequest req2 = new HttpRequest();
req2.setEndpoint('https://dummyjson.com/auth/me');
req2.setMethod('GET');
req2.setHeader('Content-Type', 'application/json');
req2.setHeader('Authorization', 'Bearer ' + token);
HttpResponse res2 = new Http().send(req2);
System.debug('getStatus 2 ' + res2.getStatus());
System.debug('getStatusCode 2 ' + res2.getStatusCode());
System.debug('getBody 2 ' + res2.getBody());

