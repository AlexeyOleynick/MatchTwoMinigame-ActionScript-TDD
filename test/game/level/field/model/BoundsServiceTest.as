/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.field.model {
	import flash.geom.Rectangle;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;

	public class BoundsServiceTest {

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
			assertTrue(boundsService.isOutOfBounds(110, 10));
		}

		[Test]
		public function shouldReturnFalseIfPointIsInBounds():void
		{
			assertFalse(boundsService.isOutOfBounds(10, 10));
		}

		[Test]
		public function shouldReturnWidth():void
		{
			assertTrue(boundsService.getWidth() == 100);
		}

	}
}
