/**
 * Created by OOliinyk on 2/15/14.
 */
package game.level.field.model.filter {
	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;
	import game.level.field.model.bounds.IBoundsService;
	import game.level.field.model.vo.CardVo;

	public class RemovalFilter implements ICardFilter {
		[Inject]
		public var fieldBoundsService:IBoundsService;

		public function filter(cardCollection:ICardCollection):ICardCollection
		{
			var filteredCollection:ICardCollection = new VectorCardCollection();
			for each (var cardVo:CardVo in cardCollection.getAll()){
				if(fieldBoundsService.isOutOfBounds(cardVo.x, cardVo.y)){
					filteredCollection.add(cardVo);
				}
			}

			return filteredCollection;
		}
	}
}
