/**
 * Created by OOliinyk on 2/16/14.
 */
package game.level.field.model.generator {
	import flash.events.Event;

	import game.level.card.model.ICardCollection;
	import game.level.field.model.bounds.IBoundsService;
	import game.level.field.model.solution.ISolutionService;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.number.lessThanOrEqualTo;
	import org.hamcrest.object.equalTo;

	public class CardProducerTest {

		private var cardProducer:InsideBoundsCardProducer;

		[Before(async, timeout=5000)]
		public function prepareMockolates():void
		{
			Async.handleEvent(this, prepare(IBoundsService, ISolutionService), Event.COMPLETE, setUp);
		}


		private function setUp(e:Event, passThroughData:Object):void
		{
			cardProducer = new InsideBoundsCardProducer();
			var boundsService:IBoundsService = nice(IBoundsService);
			stub(boundsService).method('getWidth').returns(300);
			cardProducer.boundsService = boundsService;

			var solutionService:ISolutionService = nice(ISolutionService);
			cardProducer.solutionService = solutionService;
		}

		[Test]
		public function shouldGenerateCardInsideBounds():void
		{

			stub(cardProducer.solutionService).method('getSolution').returns(true);

			for(var cardsCount:int = 0; cardsCount < 100; cardsCount++){
				var createdCollection:ICardCollection = cardProducer.produce();
				assertThat(createdCollection.getFirst().x, greaterThanOrEqualTo(0));
				assertThat(createdCollection.getFirst().x, lessThanOrEqualTo(300));
			}
		}


		[Test]
		public function shouldNotProduceCardIfSolutionServiceReturnsFalse():void
		{
			stub(cardProducer.solutionService).method('getSolution').returns(false);
			for(var cardsCount:int = 0; cardsCount < 100; cardsCount++){
				var createdCollection:ICardCollection = cardProducer.produce();
				assertThat(createdCollection.getSize(), equalTo(0));
			}
		}
	}
}
