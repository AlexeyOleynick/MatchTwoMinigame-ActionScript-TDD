package core.external.texture {
	import flash.display.Bitmap;

	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;

	public class EmbedSpriteSheetInfoProviderTest {


		private var spriteSheetInfoProvider:EmbedSpriteSheetInfoProvider;

		[Before]
		public function setUp():void
		{
			spriteSheetInfoProvider = new EmbedSpriteSheetInfoProvider();
		}

		[Test]
		public function shouldReturnXML():void
		{
			assertNotNull(spriteSheetInfoProvider.getXML());
			assertTrue(spriteSheetInfoProvider.getXML() is XML);
		}

		[Test]
		public function shouldReturnBitmap():void
		{
			assertNotNull(spriteSheetInfoProvider.getBitmap());
			assertTrue(spriteSheetInfoProvider.getBitmap() is Bitmap);
		}
	}
}
