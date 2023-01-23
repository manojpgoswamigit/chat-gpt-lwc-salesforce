/*
@description       : Salesforce+Chat-GPT LWC is used to get your query response from Chat GPT Open AI (It will give you sample code).
@author            : Prafull Jain
@email             : Prafulljaincp@gmail.com
@last modified on  : 12-11-2022
@last modified by  : Prafull Jain
Modifications Log 
Ver   Date         Author         Modification
1.0   12-11-2022   Prafull Jain   Initial Version
1.1   17-11-2022   Prafull Jain   Updated escaped character issue

*/
public with sharing class ChatGPTIntegrationController {
    private static String CHAT_GPT_KEY = System.Label.Chat_GPT_API_Key;
    private static final String ENDPOINT ='https://api.openai.com/v1/completions';
    
    //@method   : getResponseFromChatGPT
    //@param    : searchQuery
    //@description  : Below method is used in Salesforce+Chat GPT integration LWC as Controller to make callout
    //                to Chat GPT and return response/error from this method
    @AuraEnabled
    public static String getResponseFromChatGPT(String searchQuery){
        try{
            //String seachQueryEscaped = String.escapeSingleQuotes(searchQuery).trim();
            //Removed String.escapeSingleQuotes as it causing issue for don't and isn't
            String seachQueryEscaped = (searchQuery).trim();
            Http http = new Http();
            String reqBody = '{"model": "text-davinci-003","prompt":"'
                +seachQueryEscaped+
                '","max_tokens": 4000,"temperature": 0,'
                +'"stream": false,"top_p": 1}';
            System.debug('Query '+seachQueryEscaped+' '+reqBody);
            HttpRequest request = new HttpRequest();
            request.setEndpoint(ENDPOINT);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer '+String.escapeSingleQuotes(CHAT_GPT_KEY).trim());
            //Setting timeout to max 120 second to get whole response from Chat GPT Open API
            request.setTimeout(120000);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            // Set the body as a JSON object
            request.setBody(reqBody);
            HttpResponse response = http.send(request);
            // Parse the JSON response
            if(response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getBody());
                return response.getBody();
            }
            return response.getBody();
        }catch(Exception ex){
            System.debug('Exception in Catch of Server-Side Controller '+ex);
            throw new AuraHandledException(ex.getMessage());
        }
    }
}