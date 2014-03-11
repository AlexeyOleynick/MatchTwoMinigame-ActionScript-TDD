/**
 * Created by OOliinyk on 2/16/14.
 */
package game.level.field.model.updater {
	import game.level.card.model.ICardCollection;

	public interface ICardUpdater {

		function update(cardCollection:ICardCollection):void;

	}
}
