/**
 * Created by OOliinyk on 1/18/14.
 */
package game.level.card.model {
	import game.level.field.model.vo.CardVo;

	import org.casalib.collection.List;

	public class VectorCardCollection implements ICardCollection {

		private var list:List = new List();

		public function add(...args):void
		{
			for each (var cardVo:CardVo in args){
				list.addItem(cardVo);
			}
		}


		public function closeAll():void
		{
			for each (var cardVo:CardVo in list.toArray()){
				cardVo.opened = false;
			}
		}

		public function getOpenedWithDifferentTypes():ICardCollection
		{
			var openedCards:VectorCardCollection = new VectorCardCollection();
			for each (var cardVo:CardVo in getAll()){
				if(cardVo.opened) openedCards.add(cardVo);
			}

			if(openedCards.getSize() > 1){
				var type:int = openedCards.getFirst().type;
				for each (var openedCardVo:CardVo in openedCards.getAll()){
					if(type != openedCardVo.type) return openedCards;
				}
			}

			return new VectorCardCollection();
		}

		public function getOpened():ICardCollection
		{
			var matchedCards:VectorCardCollection = new VectorCardCollection();
			for each (var cardVo:CardVo in list.toArray()){
				if(cardVo.opened) matchedCards.add(cardVo);
			}
			return matchedCards;
		}

		public function getFirst():CardVo
		{
			return list.getItemAt(0);
		}

		public function contains(cardVo:CardVo):Boolean
		{
			return list.contains(cardVo);
		}

		public function getAll():Vector.<CardVo>
		{
			var vector:Vector.<CardVo> = new Vector.<CardVo>();
			for each (var cardVo:CardVo in list.toArray()){
				vector.push(cardVo);
			}
			return vector;
		}

		public function getSize():int
		{
			return list.size;
		}

		public function addCards(cardCollection:ICardCollection):void
		{
			for each (var cardVo:CardVo in cardCollection.getAll()){
				list.addItem(cardVo);
			}
		}

		public function remove(cardVo:CardVo):void
		{
			list.removeItem(cardVo);
		}

		public function removeCards(cardCollection:ICardCollection):void
		{
			var cardArray:Array = new Array();
			for each (var cardVo:CardVo in cardCollection.getAll()) cardArray.push(cardVo);
			var listToSubtract:List = new List(cardArray);
			list.removeItems(listToSubtract);
		}
	}
}
