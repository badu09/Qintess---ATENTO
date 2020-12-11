global class ScheduleGetCallData implements Schedulable {
	//public static String CRON_EXP = '0 24 18 * * ?';
	public static String CRON_EXP = '0 {0} {1} ? * *';
	private static Integer addMinutes {
		get; set;
	}

	global static String scheduleIt(Integer minutes, Integer minutesGap) {
		System.debug('Inicío: ScheduleGetCallData');

		ScheduleGetCallData scheduleGetCallData = new ScheduleGetCallData();
		addMinutes = minutes;
		String jobName = 'Get Call Data(Sucesso do Insucesso)';
		Datetime nextScheduleTime = system.now().addMinutes(addMinutes + minutesGap);
		string strMinutes = string.valueof(nextScheduleTime.minute());
		string strHours = String.valueOf(nextScheduleTime.hour());
		CRON_EXP = String.format(CRON_EXP, new List<String>{strMinutes, strHours});

		return System.schedule(jobName, CRON_EXP, scheduleGetCallData);
	}

	global void execute(SchedulableContext ctx) {
		getCallData();
		system.abortJob(ctx.getTriggerId());
		System.debug('Fim: ScheduleGetCallData');
		scheduleIt(20, 0);
	}

	@future(callout=true)
	public static void getCallData()
		{
			try {
				Datetime agora = Datetime.now();
				Datetime minutosAntes = agora.addMinutes(-30);
				BOOlos.getCallData(minutosAntes, agora);
			} catch (Exception ex) {
				System.debug('Exception: ' + ex.getStackTraceString() + ' - Message: ' + ex.getMessage());
			}
		}

}