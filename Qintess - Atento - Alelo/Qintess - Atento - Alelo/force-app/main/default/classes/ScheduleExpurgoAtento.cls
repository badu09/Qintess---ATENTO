global class ScheduleExpurgoAtento implements Schedulable
{
    global void execute(SchedulableContext ctx)
    {
        BOExpurgo.getInstance().scheduleExpurgo();
    }   
}