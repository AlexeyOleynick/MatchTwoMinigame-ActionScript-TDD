package core.external.texture {
	import flash.display.Sprite;
	import flash.events.Event;

	import mockolate.prepare;

	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.async.Async;
	[Ignore(description='Starling Texture.fromBitmap() does not work without stage')]
	public class SpriteSheetTextureServiceTest extends Sprite {


		[Before(async)]
		public function preapareMocks():void
		{
			Async.handleEvent(this, prepare(ISpriteSheetInfoProvider), Event.COMPLETE, setUp);
		}


		private var textureService:SpriteSheetTextureService;

		public function setUp(event:Event, passThroughData:Object):void
		{
			var spriteSheetProvider:EmbedSpriteSheetInfoProvider = new EmbedSpriteSheetInfoProvider();
			textureService = new SpriteSheetTextureService(spriteSheetProvider);
		}

		[Test]
		public function shouldReturnTexture():void
		{
			assertNotNull(textureService.getTexture('close'));
		}
	}
}
