package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 賓果九宮格上的物件
	 * 
	 * RollOver: lv1->
	 * RollOut: lv2->
	 * Selected RollOver: lv3->
	 * Selected RollOut: lv4->
	 * 
	 * @author jacky
	 */
	public class BaseBingoItem extends BaseBtn 
	{		
		public var mc:MovieClip;
		private var _enable:Boolean;
		private var _id:int; // 記錄選取 BaseBtnItem 的 id
		private var _last_id:int; // 記錄選取 BaseBtnItem 的上一個 id
		
		public function BaseBingoItem() 
		{
			//this.scaleX = this.scaleY = .5;
			_id = _last_id = 0;
			enable = false;
			mc.stop();
			
			onClick = function():void {
				// close icon
				// this.name: bingo_item1
				trace('new Event(BaseBingoItemClose)');
				dispatchEvent(new Event("BaseBingoItemClose", true));
				enable = false;
			}
			onRollOver = function():void {
						gotoAndPlay("lv1");
			}
			onRollOut = function():void {
						gotoAndPlay("lv2");
			}
		}		
		
		public function goto(__fn:int):void 
		{
			// 記錄原先的 id
			_last_id = _id;
			if (enable) dispatchEvent(new Event("BaseBingoItemSwitch", true));
			// 新的 id
			gotoandstop(__fn);
		}
		
		public function gotoandstop(__fn:int):void 
		{
			_id = __fn;
			mc.gotoAndStop(__fn);
			enable = true;
		}
		
		public function reset():void {
			_id = _last_id = 0;
			enable = false;
			mc.gotoAndStop(1);
		}
		
		public function get enable():Boolean 
		{
			return _enable;
		}
		
		public function set enable(value:Boolean):void 
		{
			if (!value) {
				_id = _last_id = 0;
			}
			_enable = value;
			this.visible = _enable;
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
		public function get last_id():int 
		{
			return _last_id;
		}
		
		public function set last_id(value:int):void 
		{
			_last_id = value;
		}
	}

}