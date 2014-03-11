/**
 * Created by OOliinyk on 2/16/14.
 */
package game.level.field.model.updater {
	import game.level.card.model.ICardCollection;
	import game.level.field.model.vo.CardVo;

	public class CardPositionUpdater implements ICardUpdater {

		internal const SPEED:Number = 0.1;

		public function update(cardCollection:ICardCollection):void
		{
			for each (var cardVo:CardVo in cardCollection.getAll()){
				cardVo.y += SPEED;
			}
		}
	}
}
