import { LightningElement, track } from 'lwc';
import getResponseFromChatGPT from '@salesforce/apex/ChatGPTIntegrationController.getResponseFromChatGPT';

export default class ChatGPTIntegration extends LightningElement {
    //Below exceptionList is used to show Chat GPT Link
    exceptionList = ['vf', 'visual force page', 'visualforce page', 'lwc', 'aura', 'xml', 'lightning web component', 'html', 'lightning'];
    //To show loading spinner 
    isSpinner = false;
    //Taking responses in below variables from Chat GPT controller
    @track responseFromGPT = '';
    @track responseTextLWCJS = '';

    //Below variable is used to conditionally show popup of textarea
    isOpen = false;
    //Below variable is used to conditionally show search button
    isSearchEnabled = false;
    //Taking textarea value in below variables 
    searchQuery = '';

    //Below variables is used to conditionally show Chat GPT links & error section on div
    isError = false;
    catchErrorMessage = '';


    //To show helptext 
    HELP_TXT_MSG = 'Note: This is just a Sample Response/Code, It needs to be modified as per your business need or your Salesforce Org Structure!!';
    //To show examples of queries that we can use to send to Chat GPT
    EXAMPLES_MSG = '';

    //Setting textarea placeholder message
    connectedCallback() {
        this.EXAMPLES_MSG = "Examples --> \n 1. write an Apex Class that sends SMS to the Entered Number using Twilio.  \n\n";
        this.EXAMPLES_MSG = this.EXAMPLES_MSG + "2. write an apex class to show account detail in lightning web component \n\n";
        this.EXAMPLES_MSG = this.EXAMPLES_MSG + "3. write validation rule on account to not change name that have value previously \n\n";
    }
    //Below code is used to Open popup window to get your query
    handleProcess(event) {
        event.preventDefault();
        this.isOpen = true;
    }
    //Below code is used to Close popup window & reset values
    close(event) {
        event.preventDefault();
        this.isSpinner = false;
        this.isOpen = false;
        this.reset();
        this.isError = false;
        this.isSearchEnabled = false
    }
    //Below code invoked when you enter your query into textarea
    updateSearchQuery(event) {
        event.preventDefault();
        this.searchQuery = event.detail.value;
        this.isSearchEnabled = (this.searchQuery) ? true : false;
    }

    //Below code is used to reset string type values
    reset() {
        this.responseFromGPT = '';
        this.responseTextLWCJS = '';
        this.catchErrorMessage = '';
    }
    //Below code is used to chat gpt link information when entered query have some words in
    //exceptionList or found any error
    get chatGPTLinkInforBlock() {
        let result = false;
        this.exceptionList.forEach((values => {
            if (this.searchQuery.includes(values)) {
                result = true;
            }
        }))
        if (!result) {
            result = (this.catchErrorMessage) ? true : false;
        }
        return result;
    }
    //Below code is responsible for handling response & error message from Chat GPT/Apex Server Side Controller
    fetchResponse(event) {
        event.preventDefault();
        this.reset();
        this.isSpinner = true;
        this.searchQuery = this.searchQuery.trim() + ' in salesforce';
        console.log('search ' + this.searchQuery);

        getResponseFromChatGPT({ searchQuery: this.searchQuery })
            .then(result => {
                this.isSpinner = false;
                let response = JSON.parse(JSON.stringify(JSON.parse(result)));
                console.log('Response from Chat GPT --> ' + JSON.stringify(response));
                //Below if is used to check whether Chat GPT have errors of not
                if (response.error) {
                    this.isError = true;
                    this.responseFromGPT = response.error.message;
                } else if (response.choices[0].text) {
                    this.responseFromGPT = response.choices[0].text;
                    this.responseFromGPT = this.responseFromGPT.replace(/\n/g, "<br />");

                    this.responseTextLWCJS = (response.choices[0].text.includes('<script>')) ? 'JS File: ' + response.choices[0].text.split('<script>')[1] : '';
                    this.responseTextLWCJS = this.responseTextLWCJS.replace(/\n/g, "<br />");

                    this.responseFromGPT = this.responseFromGPT + this.responseTextLWCJS;
                    this.responseFromGPT = (this.responseFromGPT.includes('XML File:')) ? this.responseFromGPT.split('XML File:')[0] : this.responseFromGPT;

                    this.responseFromGPT.trim();
                }
            })
            .catch(error => {
                this.isError = true;
                this.isSpinner = false;
                this.catchErrorMessage = error.body.message;

                console.log('error in catch JS --> ' + JSON.stringify(error));
            });

    }
}