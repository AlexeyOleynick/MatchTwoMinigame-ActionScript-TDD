/**
 * Created by OOliinyk on 1/11/14.
 */
package game.level.field.view {
	import game.level.card.view.ICardView;

	import starling.display.Sprite;

	//todo: add test
	public class FieldContainer extends Sprite implements IFieldContainer {


		public function getView():Sprite
		{
			return this;
		}


		public function addCard(cardView:ICardView):void
		{
			addChild(cardView.getView());
		}
	}
}
