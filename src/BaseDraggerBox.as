package  
{
	import com.greensock.easing.Strong;
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * 滑鼠拖拉的物件
	 * 
	 * @author flashisobar
	 */
	public class BaseDraggerBox extends MovieClip 
	{
		private var _id:Number; // 拖拉物件所顯示的影格
		private var _ox:Number; // 原先 BaseBtnItem 的座標 x
		private var _oy:Number; // 原先 BaseBtnItem 的座標 y
		
		public function BaseDraggerBox() 
		{
			stop();
			//scaleX = scaleY = .5;
			_id = 1;
		}
		
		// public methods
		public function init(__obj:Object):void 
		{
			id = __obj.id;
			ox = __obj.ox;
			oy = __obj.oy;
			show();
		}
		
		public function releaseOutSide():void 
		{
			dispatchEvent(new Event("BaseDraggerBoxReleaseOutSide", true));
			TweenMax.to(this, .5, { x:ox, y:oy, autoAlpha:0, ease:Strong.easeOut } );
		}
		
		public function off():void 
		{
			TweenMax.to(this, 0, { autoAlpha:0 } );
		}
		
		public function show():void 
		{
			TweenMax.to(this, 0, { autoAlpha:1 } );
		}
		
		// public getter/setters
		public function get id():Number 
		{
			return _id;
		}
		
		public function set id(value:Number):void 
		{
			_id = value;
			gotoAndStop(_id);
		}
		
		public function get ox():Number 
		{
			return _ox;
		}
		
		public function set ox(value:Number):void 
		{
			_ox = value;
			x = ox;
		}
		
		public function get oy():Number 
		{
			return _oy;
		}
		
		public function set oy(value:Number):void 
		{
			_oy = value;
			y = oy;
		}
		
	}

}