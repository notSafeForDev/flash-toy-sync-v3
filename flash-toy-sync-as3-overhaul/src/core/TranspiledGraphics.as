package core {
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author notSafeForDev
	 */
	public class TranspiledGraphics {
		
		private var graphics : Graphics;
		
		public function TranspiledGraphics (_graphics : Graphics) {
			graphics = _graphics;
		}
		
		public function beginFill(_color : Number, _alpha : Number = 1) : void {
			graphics.beginFill(_color, _alpha);
		}
		
		public function moveTo(_x : Number, _y : Number) : void {
			graphics.moveTo(_x, _y);
		}
		
		public function lineTo(_x : Number, _y : Number) : void {
			graphics.lineTo(_x, _y);
		}
		
		public function curveTo(_controlX : Number, _controlY : Number, _anchorX : Number, _anchorY : Number) : void {
			graphics.curveTo(_controlX, _controlY, _anchorX, _anchorY);
		}
		
		public function drawRect(_x : Number, _y : Number, _width : Number, _height : Number) : void {
			graphics.drawRect(_x, _y, _width, _height);
		}
		
		public function drawRoundedRect(_x : Number, _y : Number, _width : Number, _height : Number, _radius : Number) : void {
			graphics.drawRoundRect(_x, _y, _width, _height, _radius, _radius);
		}
		
		public function clear() : void {
			graphics.clear();
		}
	}
}