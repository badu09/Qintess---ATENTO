global class ScheduleMetaRealizada Implements Schedulable {

	public static String CRON_EXP = '0 {0} {1} ? * *';
	private static Integer addMinutes {
		get; set;
	}

	global static String scheduleIt(Integer minutes, Integer minutesGap) {

		ScheduleMetaRealizada scheduleMetaRealizada= new ScheduleMetaRealizada();
		addMinutes = minutes;

		string jobName = 'Meta Realizada';

		Datetime nextScheduleTime = system.now().addMinutes(addMinutes + minutesGap);
		string strMinutes = string.valueof(nextScheduleTime.minute());
		string strHours = String.valueOf(nextScheduleTime.hour());
		CRON_EXP = String.format(CRON_EXP, new List<String>{strMinutes, strHours});


		return System.schedule(jobName, CRON_EXP, scheduleMetaRealizada);
	}

	global void execute(SchedulableContext ctx){
		sincronizar();
		system.abortJob(ctx.getTriggerId());
		System.debug('Fim: scheduleMetaRealizada');
		scheduleIt(5, 0);
	}

	public static void sincronizar() {
		BOMetaRealizada.verificaRealizadaImplantacao();
		BOMetaRealizada.verificaRealizadaVendas();
	}
}