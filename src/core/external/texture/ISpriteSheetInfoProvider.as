package core.external.texture {
	import flash.display.Bitmap;

	public interface ISpriteSheetInfoProvider {
		function getBitmap():Bitmap;
		function getXML():XML;
	}
}
