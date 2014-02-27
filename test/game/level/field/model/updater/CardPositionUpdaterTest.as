/**
 * Created by OOliinyk on 2/16/14.
 */
package game.level.field.model.updater {
	import game.level.field.controller.CardVo;
	import game.level.field.controller.ICardCollection;
	import game.level.field.controller.VectorCardCollection;

	import org.flexunit.asserts.assertEquals;

	public class CardPositionUpdaterTest {

		[Test]
		public function shouldUpdatePosition():void
		{
			var cardUpdater:CardPositionUpdater = new CardPositionUpdater();

			var cardCollection:ICardCollection = new VectorCardCollection();
			var cardVo:CardVo = new CardVo(10, 10, 5);
			cardCollection.add(cardVo);

			cardUpdater.update(cardCollection);
			assertEquals(10 + cardUpdater.SPEED, cardVo.y);
		}
	}
}
