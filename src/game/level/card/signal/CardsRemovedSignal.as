package game.level.card.signal {
	import game.level.card.model.ICardCollection;

	import org.osflash.signals.Signal;

	public class CardsRemovedSignal extends Signal {
		public function CardsRemovedSignal()
		{
			super(ICardCollection);
		}
	}
}
