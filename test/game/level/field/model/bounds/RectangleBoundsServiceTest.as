/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.field.model.bounds {
	import flash.geom.Rectangle;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class RectangleBoundsServiceTest {

		private var rectangle:Rectangle = new Rectangle(0, 0, 100, 100);
		private var boundsService:RectangleBoundsService = new RectangleBoundsService();


		[Before]
		public function setUp():void
		{
			boundsService.setBounds(rectangle);
		}

		[Test]
		public function shouldReturnTrueIfPointIsOutOfBounds():void
		{
			assertThat(boundsService.isOutOfBounds(110, 10), equalTo(true));
		}

		[Test]
		public function shouldReturnFalseIfPointIsInBounds():void
		{
			assertThat(boundsService.isOutOfBounds(10, 10), equalTo(false));
		}

		[Test]
		public function shouldReturnWidth():void
		{
			assertThat(boundsService.getWidth(), equalTo(100));
		}

	}
}
