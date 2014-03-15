/**
 * Created by OOliinyk on 1/11/14.
 */
package game.level.field.controller {
	import core.external.texture.ITextureService;
	import core.stage.BasicContextModel;
	import core.stage.IContextModel;
	import core.stage.signal.AddToStageSignal;

	import flash.events.Event;
	import flash.geom.Rectangle;

	import game.level.field.model.bounds.IBoundsService;
	import game.level.field.view.IFieldContainer;

	import mockolate.capture;
	import mockolate.ingredients.Capture;
	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;

	import starling.textures.Texture;

	public class AddFieldCommandTest {


		private var addFieldCommand:AddFieldCommand;

		[Before(async)]
		public function prepareMocks():void
		{
			Async.handleEvent(this, prepare(AddToStageSignal, IBoundsService, Texture, ITextureService), Event.COMPLETE, setUp);
		}


		public function setUp(event:Event, passThroughData:Object):void
		{

			addFieldCommand = new AddFieldCommand();
			addFieldCommand.boundsService = nice(IBoundsService);
			addFieldCommand.addToStageSignal = nice(AddToStageSignal);

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
			addFieldCommand.execute();
			assertThat(addFieldCommand.addToStageSignal, received().method('dispatch').args(instanceOf(IFieldContainer)));
		}

		[Test]
		public function shouldSetBoundsForBoundsService():void
		{
			var captured:Capture = new Capture();
			stub(addFieldCommand.boundsService).method("setBounds").args(capture(captured));
			addFieldCommand.execute();

			var rectangle:Rectangle = captured.value as Rectangle;

			assertThat(rectangle.width, equalTo(100));
			assertThat(rectangle.height, equalTo(300));
		}
	}
}
