/**
 * Created by OOliinyk on 2/16/14.
 */
package game.level.field.model.generator {
	import game.level.field.controller.ICardCollection;

	public interface ICardProducer {

		function produce():ICardCollection;
	}
}
