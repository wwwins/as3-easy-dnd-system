package  
{
	import com.greensock.TweenMax;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import iqcat.events.DraggerEvent;
	import iqcat.utility.ArrayUtil;
	import iqcat.utility.Dragger;
	
	/**
	 * easy drag and drop system
	 * 
	 * scrollbar: JPPScrollbarKit(alumican.net<Yukiya Okuda>)
	 * icon: Hongkiat.com(http://www.hongkiat.com/blog/glossy-e-commerce-icon-set/)
	 * 
	 * @author flashisobar
	 */
	/*
	 * var myClass:Class = getDefinitionByName('Item1') as Class;
	 * error: [Fault] exception, information=ReferenceError: Error #1065: Variable Item1 is not defined.
	 * 
	 * fixed: assets.swf -> Add To Library -> Options -> Included library(include completely)
	 */
	public class GamePanel extends MovieClip 
	{
		// on stage
		public var scrollbar:MovieClip;
		
		// for as:
		private var _this:MovieClip;
		
		// 九宮格感應區
		public var hitarea1:MovieClip;
		public var hitarea2:MovieClip;
		public var hitarea3:MovieClip;
		public var hitarea4:MovieClip;
		public var hitarea5:MovieClip;
		public var hitarea6:MovieClip;
		public var hitarea7:MovieClip;
		public var hitarea8:MovieClip;
		public var hitarea9:MovieClip;
		
		// 九宮格物件
		public var bingo_item1:BaseBingoItem;
		public var bingo_item2:BaseBingoItem;
		public var bingo_item3:BaseBingoItem;
		public var bingo_item4:BaseBingoItem;
		public var bingo_item5:BaseBingoItem;
		public var bingo_item6:BaseBingoItem;
		public var bingo_item7:BaseBingoItem;
		public var bingo_item8:BaseBingoItem;
		public var bingo_item9:BaseBingoItem;

		// 拖曳的物件
		public var box:BaseDraggerBox;
		
		private var dragger:Dragger;
		
		public function GamePanel() 
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_this = scrollbar.content.contentBody;

			// init dragger
			initDragger();
			
			// click item
			stage.addEventListener("BaseBtnItem", handleClick);
			// close
			stage.addEventListener("BaseBingoItemClose", handleCloseClick);
			// switch
			stage.addEventListener("BaseBingoItemSwitch", handleItemSwitch);
			// release out side
			stage.addEventListener("BaseDraggerBoxReleaseOutSide", handleDraggerBoxReleaseOutSide);
			
		}
		
		//{#region dragger
		private function initDragger():void 
		{
			//var box:Sprite = getBox(0xff0000, 50);
			box.off();
			
			dragger = new Dragger(box);
			// 拉動區域
			//dragger.horizontal = false;
			//dragger.bufferDistance = 10;
			dragger.draggableRect = new Rectangle(90, 0, 910 - box.width, 600 - box.height);
			//dragger.addEventListener(DraggerEvent.START_DRAG, startDragger);
			//dragger.addEventListener(DraggerEvent.DRAG, traceDragger);
			dragger.addEventListener(DraggerEvent.STOP_DRAG, stopDragger);
		}
		
		private function stopDragger(e:DraggerEvent):void 
		{
			var id:int = checkCollision();
			trace('stop dragger:', id);
			if (id == 0) {
				// move back to origin position
				BaseDraggerBox(dragger.target).releaseOutSide();
				return;
			}
			var fn:int = BaseDraggerBox(dragger.target).id;
			BaseBingoItem(this['bingo_item' + id]).goto(fn);
			box.off();
		}
		
		private function startDragger(e:DraggerEvent):void 
		{
			//trace("start drag");
		}
		
		private function traceDragger(e:DraggerEvent):void 
		{
			//trace(e.value.x, e.value.y);
		}
		//}#region end

		/**
		 * handle collision
		 * @return
		 */
		private function checkCollision():int 
		{
			var mc:MovieClip;
			var p:Point = new Point(stage.mouseX, stage.mouseY);
			for (var i:int = 1; i < 10; i++) 
			{
				mc = this['hitarea' + i];
				if (mc.hitTestPoint(p.x, p.y)) {
					return i;
				}
			}
			return 0;
		}

		// create box
		private function getBox(color:uint, w:uint=10):Sprite
		{
			var box:Sprite = new Sprite();
			box.graphics.beginFill(color);
			box.graphics.drawRect(0, 0, w, w);
			box.graphics.endFill();
			return box;
		}

		/**
		 * handle BaseBtnItem click
		 * @param	e
		 */
		private function handleClick(e:Event):void 
		{
			trace("handleClick:", e.type, e.target, e.target.x, e.target.y);
			var fn:int = BaseBtnItem(e.target).id; // e.type = BaseBtnItem1
			var p:Point = _this.localToGlobal(new Point(BaseBtnItem(e.target).x, BaseBtnItem(e.target).y));
			BaseDraggerBox(dragger.target).init({tgt:dragger.target, id:fn, ox:p.x, oy:p.y});
			dragger.startDrag();
		}
		
		/**
		 * handle bingo item click close
		 * 列表上的物件要回復成可以按
		 * @param	e
		 */
		private function handleCloseClick(e:Event):void 
		{
			var id:int = BaseBingoItem(e.target).id;
			trace('handleCloseClick id:', id);
			BaseBtnItem(_this['item' + id]).selected = false;
		}
		
		/**
		 * switch bingo item and set icon list disable
		 * 列表上的物件要回復成可以按
		 * @param	e
		 */
		private function handleItemSwitch(e:Event):void 
		{
			var id:int = BaseBingoItem(e.target).last_id;
			trace('handleItemSwitch id:', id);
			BaseBtnItem(_this['item' + id]).selected = false;
		}

		/**
		 * 當物件拖曳到九宮格外
		 * 列表上的物件要回復成可以按
		 * @param	e
		 */
		private function handleDraggerBoxReleaseOutSide(e:Event):void 
		{
			var id:int = BaseDraggerBox(e.target).id;
			trace('handleDraggerBoxReleaseOutSide id:', id);
			BaseBtnItem(_this['item' + id]).selected = false;
		}
	}

}
