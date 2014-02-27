/**
 * Created by OOliinyk on 1/11/14.
 */
package game.level.field.controller {
	import core.external.texture.ITextureService;
	import core.stage.BasicContextModel;
	import core.stage.IContextModel;
	import core.stage.StageEvent;


	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.geom.Rectangle;

	import game.level.field.model.IBoundsService;
	import game.level.field.view.FieldContainer;

	import mockolate.capture;
	import mockolate.ingredients.Capture;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.hamcrest.object.instanceOf;

	import starling.textures.Texture;

	public class AddFieldCommandTest {


		private var addFieldCommand:AddFieldCommand;

		[Before(async)]
		public function preapareMocks():void
		{
			Async.handleEvent(this, prepare(IBoundsService, Texture, ITextureService), Event.COMPLETE, setUp);
		}


		public function setUp(event:Event, passThroughData:Object):void
		{

			addFieldCommand = new AddFieldCommand();
			addFieldCommand.boundsService = nice(IBoundsService);
			addFieldCommand.dispatcher = new EventDispatcher();

			var texture:Texture = nice(Texture);
			stub(texture).getter('nativeWidth').returns(100);

			var textureService:ITextureService = nice(ITextureService);
			stub(textureService).method('getTexture').returns(texture);

			addFieldCommand.textureService = textureService;
			var contextModel:IContextModel = new BasicContextModel();
			contextModel.initialize(200, 300);
			addFieldCommand.contextModel = contextModel;
		}


		[Test(async)]
		public function shouldAddFieldSpriteToContextView():void
		{
			addFieldCommand.dispatcher.addEventListener(StageEvent.ADD_TO_STAGE, Async.asyncHandler(this, eventShouldContainSprite, 100));
			addFieldCommand.execute();

		}

		private function eventShouldContainSprite(stageEvent:StageEvent, passThrough:Object):void
		{
			assertNotNull(stageEvent.getViewContainer());
			assertTrue(stageEvent.getViewContainer() is FieldContainer);
		}


		[Test]
		public function shouldSetBoundsForBoundsService():void
		{
			var captured:Capture = new Capture();
			stub(addFieldCommand.boundsService).method("setBounds").args(capture(captured));
			addFieldCommand.execute();

			var rectangle:Rectangle = captured.value as Rectangle;

			assertTrue(rectangle.width == 100);
			assertTrue(rectangle.height == 300);
		}
	}
}
