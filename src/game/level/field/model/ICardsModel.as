/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.model {
	import game.level.field.controller.CardVo;

	public interface ICardsModel {

		function stepForward():void;

		function select(cardVo:CardVo):void;

	}
}
