package game.level.card.signal {
	import game.level.card.model.ICardCollection;

	import org.osflash.signals.Signal;

	public class CardsCreatedSignal extends Signal{
		public function CardsCreatedSignal()
		{
			super(ICardCollection);
		}
	}
}
