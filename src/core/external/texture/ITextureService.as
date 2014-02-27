package core.external.texture {
	import starling.textures.Texture;

	public interface ITextureService {
		function getTexture(subTextureName:String):Texture;

		function getTextures(subTextureName:String):Vector.<Texture>;
	}
}
