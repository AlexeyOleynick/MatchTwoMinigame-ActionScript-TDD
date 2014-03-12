/**
 * Created by OOliinyk on 2/15/14.
 */
package game.level.field.model.filter {
	import flash.events.Event;

	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;
	import game.level.field.model.bounds.IBoundsService;
	import game.level.field.model.vo.CardVo;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.stub;

	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.hamcrest.object.equalTo;
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
			assertThat(filteredCollection.contains(firstCard), equalTo(false));
			assertThat(filteredCollection.contains(secondCard), equalTo(false));
			assertThat(filteredCollection.contains(thirdCard), equalTo(true));
			assertThat(filteredCollection.contains(fourthCard), equalTo(true));
		}
	}
}
