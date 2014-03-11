/**
 * Created by OOliinyk on 2/16/14.
 */
package game.level.field.model.generator {
	import game.level.card.model.ICardCollection;

	public interface ICardProducer {

		function produce():ICardCollection;
	}
}
