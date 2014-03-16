package game.level.card.signal {
	import game.level.card.model.ICardCollection;

	import org.osflash.signals.Signal;

	public class CardsUpdatedSignal extends Signal {
		public function CardsUpdatedSignal()
		{
			super(ICardCollection);
		}
	}
}
