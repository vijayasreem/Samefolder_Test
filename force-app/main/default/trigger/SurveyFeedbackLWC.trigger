trigger SurveyResponseTrigger on Survey_Response__c (before insert) {
    Map<Id, Survey_Question__c> surveyQuestions = new Map<Id, Survey_Question__c>([SELECT Id, Type__c FROM Survey_Question__c]);
    Map<Id, Survey_Question_Choice__c> surveyQuestionChoices = new Map<Id, Survey_Question_Choice__c>([SELECT Id, Choice__c FROM Survey_Question_Choice__c]);

    for (Survey_Response__c surveyResponse : Trigger.new) {
        if (surveyQuestions.containsKey(surveyResponse.Survey_Question__c)) {
            Survey_Question__c surveyQuestion = surveyQuestions.get(surveyResponse.Survey_Question__c);
            if (surveyQuestion.Type__c == 'Text') {
                surveyResponse.Answer__c = surveyResponse.Answer_Text__c;
            } else if (surveyQuestion.Type__c == 'Single Choice' || surveyQuestion.Type__c == 'Multi Choice') {
                if (surveyQuestionChoices.containsKey(surveyResponse.Answer__c)) {
                    surveyResponse.Answer__c = surveyQuestionChoices.get(surveyResponse.Answer__c).Choice__c;
                }
            }
        }
    }
}