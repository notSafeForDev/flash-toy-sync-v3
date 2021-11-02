import core.TPDisplayObject;
import flash.display.BitmapData;
import flash.geom.Matrix;
import flash.geom.Rectangle;

/**
 * ...
 * @author notSafeForDev
 */
class core.TPBitmapUtil{
	
	public static function drawToBitmap(_object : TPDisplayObject, _parent : TPDisplayObject) : TPDisplayObject {
		var bounds : Rectangle = _object.getBounds(_object);
		
		var bitmapData : BitmapData = new BitmapData(bounds.width, bounds.height, true, 0x00000000);
		var bitmapMovieClip : MovieClip = _parent.sourceDisplayObject.createEmptyMovieClip("", _parent.sourceDisplayObject.getNextHighestDepth());
		
		bitmapData.draw(_object.sourceDisplayObject, new Matrix(1, 0, 0, 1, -bounds.x, -bounds.y));
		bitmapMovieClip.attachBitmap(bitmapData, 1);
		
		return new TPDisplayObject(bitmapMovieClip);
	}
}