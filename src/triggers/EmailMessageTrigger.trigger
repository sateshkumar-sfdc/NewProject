trigger EmailMessageTrigger on EmailMessage (after insert) {
    
   if (Trigger.isAfter)
    {
        if (Trigger.isInsert)
        {
           CreateFeedOnEmailSend.MakeFeed(Trigger.newMap);
        }
    }
}