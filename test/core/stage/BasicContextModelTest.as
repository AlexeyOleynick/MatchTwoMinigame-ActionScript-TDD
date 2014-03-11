/**
 * Created by OOliinyk on 1/18/14.
 */
package core.stage {
	import org.flexunit.asserts.assertEquals;

	public class BasicContextModelTest {

		[Test]
		public function ShouldReturnCorrectValuesOnInitialize():void
		{
			var contextmodel:BasicContextModel = new BasicContextModel();
			contextmodel.initialize(200, 300);
			assertEquals(contextmodel.getWidth(), 200);
			assertEquals(contextmodel.getHeight(), 300);
		}
	}
}
