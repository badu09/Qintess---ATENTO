public class ScheduleAlterarFilasConceitoM implements Schedulable{

	public Void execute(System.SchedulableContext context) {
		Database.executeBatch(new BatchAlterarFilasConceitoM());
	}
}