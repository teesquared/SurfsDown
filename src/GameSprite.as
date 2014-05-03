package
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * SpriteBase
	 *
	 * @author Tony Tyson (teesquared@twistedwords.net)
	 */
	public class GameSprite extends Sprite
	{
		protected var moveY:Number = 0;
		protected var moveX:Number = 0;

		protected var speed:Number = 4;

		protected var maxX:Number = 0;
		protected var maxY:Number = 0;

		public static const EVENT_OFFSCREEN:String = "EVENT_OFFSCREEN";
		public static const EVENT_DESTROYED:String = "EVENT_DESTROYED";

		public var active:Boolean = false;

		protected var lifespan:uint = 0;

		protected var frameCounter:uint = 0;

		/**
		 * GameSprite
		 */
		public function GameSprite()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.REMOVED_FROM_STAGE, removed);
		}

		/**
		 * init
		 *
		 * @param	e
		 */
		protected function init(e:Event):void {
			addEventListener(Event.ENTER_FRAME, enterFrame);
			active = true;
		}

		/**
		 * removed
		 *
		 * @param	e
		 */
		private function removed(e:Event):void {
			removeEventListener(Event.ENTER_FRAME, enterFrame);
			active = false;
		}
	
		/**
		 * enterFrame
		 *
		 * @param	e
		 */
		protected function enterFrame(e:Event):void {
			update();
			++frameCounter;
		}
		
		/**
		 * update
		 */
		protected function update():void 
		{
			determineMove();

			y += moveY * speed;
			x += moveX * speed;

			clampPosition();

			checkOffscreen();

			if (lifespan && --lifespan <= 0) {
				dispatchEvent(new Event(EVENT_DESTROYED));
			}
		}

		/**
		 * determineMove
		 */
		protected function determineMove():void {
			
		}
		
		/**
		 * checkOffscreen
		 */
		protected function checkOffscreen():void 
		{
			const offY:Boolean = y <= -height || y >= SurfsDown.HEIGHT + height;
			const offX:Boolean = x <= -width || x >= SurfsDown.WIDTH + width;

			if (offY || offX)
				dispatchEvent(new Event(EVENT_OFFSCREEN));
		}

		/**
		 * clampPosition
		 */
		protected function clampPosition():void {
			if (maxY) {
				if (y < 0)
					y = 0;
				if (y >= maxY)
					y = maxY - 1;
			}

			if (maxX) {
				if (x < 0)
					x = 0;
				if (x >= maxX)
					x = maxX - 1;
			}
		}

		/**
		 * setMoveX
		 *
		 * @param	moveX
		 */
		public function setMoveX(moveX:Number):void {
			this.moveX = moveX;
		}

		/**
		 * setMoveY
		 *
		 * @param	moveY
		 */
		public function setMoveY(moveY:Number):void {
			this.moveY = moveY;
		}

		/**
		 * setSpeed
		 *
		 * @param	speed
		 */
		public function setSpeed(speed:Number):void {
			this.speed = speed;
		}

		/**
		 * fire
		 *
		 * @param	x
		 * @param	y
		 */
		public function fire(x:Number, y:Number):void {
		}

		/**
		 * getBoundingBox
		 */
		public function getBoundingBox():DisplayObject {
			return this;
		}

		/**
		 * checkPointsInBounds
		 *
		 * @param	d1
		 * @param	d2
		 * @return
		 */
		public function checkPointsInBounds(d1:DisplayObject, d2:DisplayObject):Boolean {

			// bounding rect of both objects
			const b1:Rectangle = d1.getBounds(d1);
			const b2:Rectangle = d2.getBounds(d2);

			// check 4 points in global space
			const b2p1g:Point = d2.localToGlobal(b2.topLeft);
			
			if (b1.containsPoint(d1.globalToLocal(b2p1g)))
				return true;

			const b2p2g:Point = d2.localToGlobal(new Point(b2.x + b2.width, b2.y));

			if (b1.containsPoint(d1.globalToLocal(b2p2g)))
				return true;

			const b2p3g:Point = d2.localToGlobal(b2.bottomRight);

			if (b1.containsPoint(d1.globalToLocal(b2p3g)))
				return true;

			const b2p4g:Point = d2.localToGlobal(new Point(b2.x, b2.y + b2.height));

			if (b1.containsPoint(d1.globalToLocal(b2p4g)))
				return true;

			return false;
		}

		/**
		 * checkOverlap
		 *
		 * @param	bbox
		 * @return
		 */
		public function checkOverlap(otherBoundingBox:DisplayObject):Boolean {
			return checkPointsInBounds(getBoundingBox(), otherBoundingBox)
				|| checkPointsInBounds(otherBoundingBox, getBoundingBox());
		}

		/**
		 * hitTestBoundingBox
		 *
		 * @param	obj
		 * @return
		 */
		public function hitTestBoundingBox(obj:DisplayObject):Boolean 
		{
			const gameSprite:GameSprite = obj as GameSprite;
			const otherBoundingBox:DisplayObject = gameSprite ? gameSprite.getBoundingBox() : obj;

			if (!getBoundingBox().hitTestObject(otherBoundingBox))
				return false;

			if (rotation == 0 && obj.rotation == 0)
				return false;

			return checkOverlap(otherBoundingBox);
		}
	}
}
