/**
 * Created by OOliinyk on 2/15/14.
 */
package game.level.field.model.filter {
	import game.level.card.model.ICardCollection;

	public interface ICardFilter {

		function filter(cardCollection:ICardCollection):ICardCollection;


	}
}
