/*
@description       : Salesforce+Chat-GPT LWC is used to get your query response from Chat GPT Open AI (It will give you sample code).
@author            : Prafull Jain
@email             : Prafulljaincp@gmail.com
@last modified on  : 12-11-2022
@last modified by  : Prafull Jain
Modifications Log 
Ver   Date         Author         Modification
1.0   12-11-2022   Prafull Jain   Initial Version
*/
@IsTest
global class ChatGPTIntegrationControllerTest {
    
    @IsTest
    private static void testChatGPTIntegrationPostive(){
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new ChatGPTPositiveHttpCalloutMock()); 
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock. 
        Test.startTest();
        String searchQuery='write validation rule on account';
        String result = ChatGPTIntegrationController.getResponseFromChatGPT(searchQuery);
        Test.stopTest();
        // Verify that the response received contains fake values
        String acutalValue ='{"id": "cmpl-6Ln4Zw1uucA7nryIg5egKvdzifWwz", "object": "text_completion",'
            +'"created": 1670651543,"model": "text-davinci-003", "choices":'
            +'[{"text": "\n\n1. The account must have a valid email address.\n\n2. '
            +'The account must have a unique username.\n\n3. The account must have a strong password.\n\n4. The account must have a valid phone number",'
            +'"index": 0,"logprobs": null,"finish_reason": "stop"}],"usage": {"prompt_tokens": 5,"completion_tokens": 133, "total_tokens": 138}}';
        
        System.assertEquals(result,acutalValue );
    }   
    global class ChatGPTPositiveHttpCalloutMock implements HttpCalloutMock {
        // Implement this interface method
        global HTTPResponse respond(HTTPRequest request) {
            // Created a fake response for Chat GPT API
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setBody('{"id": "cmpl-6Ln4Zw1uucA7nryIg5egKvdzifWwz", "object": "text_completion",'
                             +'"created": 1670651543,"model": "text-davinci-003", "choices":'
                             +'[{"text": "\n\n1. The account must have a valid email address.\n\n2. '
                             +'The account must have a unique username.\n\n3. The account must have a strong password.\n\n4. The account must have a valid phone number",'
                             +'"index": 0,"logprobs": null,"finish_reason": "stop"}],"usage": {"prompt_tokens": 5,"completion_tokens": 133, "total_tokens": 138}}'
                            );
            response.setStatusCode(200);
            return response; 
        }
    }
}