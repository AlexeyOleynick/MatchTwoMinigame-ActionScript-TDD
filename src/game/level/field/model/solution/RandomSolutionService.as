/**
 * Created by OOliinyk on 1/12/14.
 */
package game.level.field.model.solution {
	public class RandomSolutionService implements ISolutionService {

		public function getSolution():Boolean
		{
			if(Math.random() > 0.99)return true; else return false;
		}
	}
}
