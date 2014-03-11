/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.card.model {
	import game.level.field.model.vo.CardVo;

	public interface ICardCollection {
		function add(...args):void;

		function contains(cardVo:CardVo):Boolean;

		function getAll():Vector.<CardVo>;

		function getFirst():CardVo;

		function getSize():int;

		function addCards(cardCollection:ICardCollection):void;

		function getOpenedWithDifferentTypes():ICardCollection;

		function remove(cardVo:CardVo):void;

		function getOpened():ICardCollection;

		function closeAll():void;

		function removeCards(cardCollection:ICardCollection):void
	}
}
