public class AccountAfterInsertTriggerHandler extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp) {
        AccountHelper.testAfterInsert(tp.newList);
	}
}