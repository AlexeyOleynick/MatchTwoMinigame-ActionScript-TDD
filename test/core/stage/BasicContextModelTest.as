/**
 * Created by OOliinyk on 1/18/14.
 */
package core.stage {
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class BasicContextModelTest {

		[Test]
		public function ShouldReturnCorrectValuesOnInitialize():void
		{
			var contextmodel:BasicContextModel = new BasicContextModel();
			contextmodel.initialize(200, 300);
			assertThat(contextmodel.getWidth(), equalTo(200));
			assertThat(contextmodel.getHeight(), equalTo(300));
		}
	}
}
