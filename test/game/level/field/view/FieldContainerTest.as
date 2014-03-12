package game.level.field.view {
	import flash.events.Event;

	import game.level.card.view.ICardView;

	import mockolate.nice;
	import mockolate.prepare;
	import mockolate.received;
	import mockolate.stub;

	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;

	import starling.display.Sprite;

	public class FieldContainerTest {
		private var fieldContainer:FieldContainer;


		[Before(async)]
		public function setUp():void
		{
			Async.proceedOnEvent(this, prepare(ICardView, Sprite), Event.COMPLETE);
			fieldContainer = new FieldContainer();
		}

		[Test]
		public function shouldContainOneEmptySpriteOnCreate():void
		{
			assertThat(fieldContainer.numChildren, equalTo(1));
			assertThat((fieldContainer.getChildAt(0) as Sprite).numChildren, equalTo(0));
			assertThat(fieldContainer.getChildAt(0), equalTo(fieldContainer.logiclessContainer));
		}

		[Test]
		public function shouldReturnView():void
		{
			assertThat(fieldContainer.getView(), instanceOf(Sprite));
		}

		[Test]
		public function shouldAddCardToLogicLessView():void
		{
			var cardView:ICardView = nice(ICardView);
			var cardSprite:Sprite = nice(Sprite);
			stub(cardView).method("getView").returns(cardSprite);

			fieldContainer.logiclessContainer = nice(Sprite);

			fieldContainer.addCard(cardView);

			assertThat(fieldContainer.logiclessContainer, received().method('addChild').once().args(equalTo(cardSprite)));

		}
	}
}
