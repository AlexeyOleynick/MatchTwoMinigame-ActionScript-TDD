package game.level.card.view.texture {
	import starling.textures.Texture;

	public interface ICardTextureProvider {

		function getClosedTexture():Texture;
		function getOpenedTexture(cardType:int):Texture;
		function getClosedTextureWidth():Number;
	}
}
