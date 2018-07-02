global class SeedDataProcessorScheduleClass implements schedulable
{
    global void execute(SchedulableContext sc)
    {
    SeedDataProcessorBatch SeedDataProcessorBatch = new SeedDataProcessorBatch(); //ur batch class
      database.executebatch(SeedDataProcessorBatch);
    }
}