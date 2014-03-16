package game.level.field.view.factory {
	import asx.array.inject;

	import flash.events.Event;

	import game.level.card.model.ICardCollection;
	import game.level.card.view.CardView;
	import game.level.card.view.ICardView;
	import game.level.field.model.vo.CardVo;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;

	import robotlegs.bender.framework.api.IInjector;

	public class DefaultCardViewFactoryTest {


		[Before(async)]
		public function prepareMocks():void
		{
			Async.proceedOnEvent(this, prepare(ICardCollection, IInjector, ICardView), Event.COMPLETE);
		}

		[Test]
		public function shouldGenerateViewsByCardCollection():void
		{
			var cardViewFactory:DefaultCardViewFactory = new DefaultCardViewFactory();

			cardViewFactory.injector = nice(IInjector);
			stub(cardViewFactory.injector).method('instantiateUnmapped').args(CardView).returns(nice(ICardView));

			var cardCollection:ICardCollection = nice(ICardCollection);
			var cardsVo:Vector.<CardVo> = new Vector.<CardVo>();
			cardsVo.push(new CardVo(10, 20, 0));
			stub(cardCollection).method('getAll').returns(cardsVo);

			var cardView:ICardView = cardViewFactory.generateViewsByCardCollection(cardCollection).pop();

			assertThat(cardView, instanceOf(ICardView));
			assertThat(cardView, received().method('setCardVo').arg(cardsVo.pop()))
		}
	}
}
