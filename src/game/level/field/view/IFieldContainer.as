/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.view {
	import core.stage.IViewContainer;

	import game.level.card.view.ICardView;

	public interface IFieldContainer extends IViewContainer {

		function addCard(cardView:ICardView):void;
	}
}
