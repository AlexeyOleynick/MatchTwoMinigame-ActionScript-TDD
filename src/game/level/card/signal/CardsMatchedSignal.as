package game.level.card.signal {
	import game.level.card.model.ICardCollection;

	import org.osflash.signals.Signal;

	public class CardsMatchedSignal extends Signal {
		public function CardsMatchedSignal()
		{
			super(ICardCollection);
		}

	}
}
