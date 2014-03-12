package game.level.field.model.solution {
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;

	public class RandomSolutionServiceTest {
		public function RandomSolutionServiceTest()
		{
		}

		[Test]
		public function testGetSolution():void
		{
			var randomSolutionService:RandomSolutionService = new RandomSolutionService();
			assertThat(randomSolutionService.getSolution(), instanceOf(Boolean));
		}
	}
}
