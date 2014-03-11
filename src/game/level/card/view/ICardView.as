/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.card.view {
	import core.stage.IViewContainer;

	import game.level.field.model.vo.CardVo;

	public interface ICardView extends IViewContainer {

		function setCardVo(cardVo:CardVo):void;

		function getCardVo():CardVo;

		function remove():void;

		function addSelectListener(listener:Function):void;

		function showMatchAnimation():void;
	}
}
