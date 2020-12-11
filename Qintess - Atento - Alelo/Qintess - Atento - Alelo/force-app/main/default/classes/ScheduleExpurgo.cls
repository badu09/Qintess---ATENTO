public class ScheduleExpurgo implements Schedulable{

	public Void execute(System.SchedulableContext context) {
		Database.executeBatch(new BatchExpurgo('EmailMessage'));
	}
}