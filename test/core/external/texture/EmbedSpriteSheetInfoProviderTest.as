package core.external.texture {
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;

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
			assertThat(spriteSheetInfoProvider.getXML(), notNullValue());
			assertThat(spriteSheetInfoProvider.getXML(), instanceOf(XML));
		}

		[Test]
		public function shouldReturnBitmap():void
		{
			assertThat(spriteSheetInfoProvider.getBitmap(), notNullValue());
			assertThat(spriteSheetInfoProvider.getBitmap(), notNullValue());
		}
	}
}
