package game.level.card.view.texture {
	import core.external.texture.ITextureService;

	import flash.events.Event;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	import starling.textures.Texture;

	public class CardTextureProviderTest {

		private var cardTextureProvider:CardTextureProvider;

		[Before(async)]
		public function prepareMocks():void
		{
			Async.handleEvent(this, prepare(ITextureService, Texture), Event.COMPLETE, setUp);
		}

		private var textureFromService:Texture;

		private function setUp(e:Event, passThroughData:Object):void
		{
			cardTextureProvider = new CardTextureProvider();
			cardTextureProvider.textureService = nice(ITextureService);

			textureFromService = nice(Texture);
			stub(cardTextureProvider.textureService).method('getTexture').returns(textureFromService)
		}

		[Test]
		public function shouldRequestForClosedTextureAndReturnIt():void
		{
			var texture:Texture = cardTextureProvider.getClosedTexture();
			assertThat(cardTextureProvider.textureService, received().method('getTexture').arg(CardTextureProvider.CLOSED_TEXTURE_NAME));
			assertThat(texture, equalTo(textureFromService));
		}

		[Test]
		public function shouldRequestForOpenedTextureAndReturnIt():void
		{
			var texture:Texture = cardTextureProvider.getOpenedTexture(3);
			assertThat(cardTextureProvider.textureService, received().method('getTexture').arg(CardTextureProvider.OPENED_TEXTURE_PREFIX + 3));
			assertThat(texture, equalTo(textureFromService));
		}


		[Test]
		public function shouldReturnClosedTextureWidth():void
		{
			stub(textureFromService).getter('nativeWidth').returns(100);
			assertThat(cardTextureProvider.getClosedTextureWidth(), equalTo(100));
			assertThat(cardTextureProvider.textureService, received().method('getTexture').arg(CardTextureProvider.CLOSED_TEXTURE_NAME));
		}
	}
}
