/**
 * Created by OOliinyk on 2/15/14.
 */
package game.level.field.model.filter {
	import flash.events.Event;

	import game.level.field.controller.CardVo;
	import game.level.field.controller.ICardCollection;
	import game.level.field.controller.VectorCardCollection;
	import game.level.field.model.IBoundsService;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.stub;

	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.flexunit.async.Async;
	import org.hamcrest.object.instanceOf;

	public class RemovalFilterTest {

		private var firstCard:CardVo = new CardVo(10, 20, 3);
		private var secondCard:CardVo = new CardVo(10, 20, 3);
		private var thirdCard:CardVo = new CardVo(10, 50, 3);
		private var fourthCard:CardVo = new CardVo(10, 100, 3);

		private var cardCollection:ICardCollection;

		[Before(async, timeout=5000)]
		public function prepareMockolates():void
		{
			Async.proceedOnEvent(this, prepare(IBoundsService), Event.COMPLETE);

			cardCollection = new VectorCardCollection();
			cardCollection.add(firstCard, secondCard, thirdCard, fourthCard);
		}


		[Test]
		public function ShouldFilterIfOutOfBounds():void
		{
			var removalFilter:RemovalFilter = new RemovalFilter();

			var fieldBoundsService:IBoundsService = nice(IBoundsService);

			stub(fieldBoundsService).method("isOutOfBounds").args(instanceOf(int), 50).returns(true);
			stub(fieldBoundsService).method("isOutOfBounds").args(instanceOf(int), 100).returns(true);
			stub(fieldBoundsService).method("isOutOfBounds").args(instanceOf(int), 20).returns(false);

			removalFilter.fieldBoundsService = fieldBoundsService;
			var filteredCollection:ICardCollection = removalFilter.filter(cardCollection);
			assertFalse(filteredCollection.contains(firstCard));
			assertFalse(filteredCollection.contains(secondCard));
			assertTrue(filteredCollection.contains(thirdCard));
			assertTrue(filteredCollection.contains(fourthCard));
		}
	}
}
