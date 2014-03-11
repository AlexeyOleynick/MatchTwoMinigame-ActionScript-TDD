/**
 * Created by OOliinyk on 2/16/14.
 */
package game.level.field.model.generator {
	import game.level.card.model.ICardCollection;
	import game.level.card.model.VectorCardCollection;
	import game.level.field.model.bounds.IBoundsService;
	import game.level.field.model.solution.ISolutionService;
	import game.level.field.model.vo.CardVo;

	public class InsideBoundsCardProducer implements ICardProducer {
		[Inject]
		public var boundsService:IBoundsService;
		[Inject]
		public var solutionService:ISolutionService;


		public function produce():ICardCollection
		{
			var cardCollectionToCreate:ICardCollection = new VectorCardCollection();
			if(solutionService.getSolution()){
				var cardVo:CardVo = generateNewVO();
				cardCollectionToCreate.add(cardVo);
			}
			return cardCollectionToCreate;
		}


		private function generateNewVO():CardVo
		{
			var type:int = Math.floor(Math.random() * 4) + 1;
			var x:int = Math.floor(Math.random() * boundsService.getWidth());
			var y:int = 0;
			return new CardVo(x, y, type);
		}
	}
}
