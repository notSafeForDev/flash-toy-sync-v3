package core {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TPBitmapUtil {
		
		/**
		 * Takes an existing object and draws it as a bitmap and places it inside a parent
		 * @param	_object		The object to draw as a bitmap
		 * @param	_parent		The parent to place it inside
		 * @return	The drawn bitmap
		 */
		public static function drawToBitmap(_object : TPDisplayObject, _parent : TPMovieClip) : TPDisplayObject {
			var bounds : Rectangle = _object.getBounds(_object);
			var bitmapData : BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00000000);
			
			bitmapData.draw(_object.sourceDisplayObject, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));			
			
			var bitmap : Bitmap = new Bitmap(bitmapData);
			
			_parent.sourceMovieClip.addChild(bitmap);
			
			return new TPDisplayObject(bitmap);
		}
	}
}