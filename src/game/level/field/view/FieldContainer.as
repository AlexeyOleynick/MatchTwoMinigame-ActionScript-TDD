/**
 * Created by OOliinyk on 1/11/14.
 */
package game.level.field.view {
	import game.level.card.view.ICardView;

	import starling.display.Sprite;

	public class FieldContainer extends Sprite implements IFieldContainer {

		internal var logiclessContainer:Sprite;


		public function FieldContainer()
		{
			logiclessContainer = new Sprite();
			addChild(logiclessContainer);
		}

		public function getView():Sprite
		{
			return this;
		}


		public function addCard(cardView:ICardView):void
		{
			logiclessContainer.addChild(cardView.getView());
		}
	}
}
