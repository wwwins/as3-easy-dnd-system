package 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * 列表上的物件
	 * 
	 * RollOver: lv1->
	 * RollOut: lv2->
	 * Selected RollOver: lv3->
	 * Selected RollOut: lv4->
	 * 
	 * @author jacky
	 */
	public class BaseBtnItem extends BaseBtn 
	{
		public var icons:MovieClip;
		public var hitarea:MovieClip;
		private var _selected:Boolean;
		private var _id:int;
		
		public function BaseBtnItem() 
		{
			//this.scaleX = this.scaleY = .5;
			
			//var buf:String = getQualifiedClassName(this);
			_id = int(this.name.substr(4));
			
			onClick = function():void {
				
			}
			onRollOver = function():void {
				if (_selected)
						gotoAndPlay("lv3");
				else
						gotoAndPlay("lv1");
				dispatchEvent(new Event("BaseTipsOver", true));
			}
			onRollOut = function():void {
				if (_selected)
						gotoAndPlay("lv4");
				else
						gotoAndPlay("lv2");
				dispatchEvent(new Event("BaseTipsOut", true));
			}
			onDown = function():void {
				if (!_selected) {
					// new Event("BaseBtnItem1")
					trace('new Event("BaseBtnItem")');
					dispatchEvent(new Event("BaseBtnItem", true));
					selected = true;
				}
			}

		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			if (_selected)
				gotoAndStop("lv4");
			else
				gotoAndStop("lv1");
		}
		
		public function get id():int 
		{
			return _id;
		}
		
		public function set id(value:int):void 
		{
			_id = value;
		}
		
	}

}