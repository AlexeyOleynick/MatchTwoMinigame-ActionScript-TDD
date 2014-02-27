package core.external.texture {
	import flash.display.Bitmap;

	public class EmbedSpriteSheetInfoProvider implements ISpriteSheetInfoProvider{

		[Embed(source="/../media/sprite.xml", mimeType="application/octet-stream")]
		private const AssetsLayoutXml:Class;

		[Embed(source="/../media/sprite.png")]
		private const AssetsSpriteSheet:Class;


		public function getBitmap():Bitmap
		{
			return new AssetsSpriteSheet();
		}

		public function getXML():XML
		{
			return XML(new AssetsLayoutXml());
		}
	}
}
