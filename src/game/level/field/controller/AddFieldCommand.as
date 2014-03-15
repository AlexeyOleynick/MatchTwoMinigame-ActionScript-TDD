/**
 * Created by OOliinyk on 1/11/14.
 */
package game.level.field.controller {
	import core.external.texture.ITextureService;
	import core.stage.IContextModel;
	import core.stage.signal.AddToStageSignal;

	import flash.geom.Rectangle;

	import game.level.field.model.bounds.IBoundsService;
	import game.level.field.view.FieldContainer;

	import robotlegs.bender.bundles.mvcs.Command;

	public class AddFieldCommand extends Command {

		[Inject]
		public var boundsService:IBoundsService;
		[Inject]
		public var contextModel:IContextModel;
		[Inject]
		public var textureService:ITextureService;
		[Inject]
		public var addToStageSignal:AddToStageSignal;

		override public function execute():void
		{
			var cardTextureWidth:Number = textureService.getTexture('closed').nativeWidth;
			boundsService.setBounds(new Rectangle(0, 0, contextModel.getWidth() - cardTextureWidth, contextModel.getHeight()));
			addToStageSignal.dispatch(new FieldContainer());
		}
	}
}
