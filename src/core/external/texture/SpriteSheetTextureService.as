package core.external.texture {
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	/**
	 * @author OOliinyk
	 */
	public class SpriteSheetTextureService implements ITextureService {

		private var assetsTextureAtlas:TextureAtlas;


		public function SpriteSheetTextureService(spriteSheetInfo:ISpriteSheetInfoProvider)
		{
			assetsTextureAtlas = new TextureAtlas(Texture.fromBitmap(spriteSheetInfo.getBitmap()), spriteSheetInfo.getXML());
		}

		public function getTexture(subTextureName:String):Texture
		{
			return assetsTextureAtlas.getTexture(subTextureName);
		}

		public function getTextures(subTextureName:String):Vector.<Texture>
		{
			return assetsTextureAtlas.getTextures(subTextureName);
		}

	}
}
