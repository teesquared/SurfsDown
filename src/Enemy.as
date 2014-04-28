package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * Enemy
	 *
	 * @author Tony Tyson (teesquared@twistedwords.net)
	 */
	public class Enemy extends GameSprite 
	{
		protected var targetPoint:Point = new Point();
		public var health:uint = 1;

		protected static const NEAR_DISTANCE:Number = 4;

		/**
		 * Enemy
		 */
		public function Enemy() {
			super();
		}

		/**
		 * init
		 *
		 * @param	e
		 */
		override protected function init(e:Event):void 
		{
			super.init(e);

			pickStart();

			pickTargetPoint();
		}
	
		/**
		 * determineMove
		 */
		override protected function determineMove():void {

			if (isNearTargetPoint()) {
				pickTargetPoint();
			}

			moveToTargetPoint();
		}

		/**
		 * moveToTargetPoint
		 */
		protected function moveToTargetPoint():void 
		{
			const deltaX:Number = targetPoint.x - x;
			const deltaY:Number = targetPoint.y - y;

			const distance:Number = Math.sqrt(deltaX * deltaX + deltaY * deltaY);

			moveX = deltaX / distance;
			moveY = deltaY / distance;

			rotation = Utils.RADS_TO_DEGREES * Math.atan2(moveY, moveX) + 90;

			/** @todo
			const r:Number = RADS_TO_DEGREES * Math.atan2(moveY, moveX) + 90;
			rotation = rotation + 0.2 * (r - rotation);
			*/

			//scaleX = rotation < 0 ? -1 : 1;
			if (moveX) {
				const c1:Boolean = moveX < 0 && scaleX > 0;
				const c2:Boolean = moveX > 0 && scaleX < 0;

				if (c1 || c2)
					scaleX = -scaleX;
			}

			/*
			if (y <= -height || y >= SurfsDown.HEIGHT + height)
				alpha = 0;
			else
				alpha = 1 - (y + height) / (SurfsDown.HEIGHT + 2 * height);
			*/

			/// @todo
			alpha = 1;
		}

		/**
		 * pickTargetPoint
		 */
		protected function pickTargetPoint():void {

			const sw:Number = SurfsDown.WIDTH;
			const sh:Number = SurfsDown.HEIGHT;

			/*
			targetPoint.x = -sw / 2 + sw * 2 * Math.random();
			targetPoint.y = -sh / 2 + sh * 2 * Math.random();
			*/

			const rw:Number = sw / 2 * Math.random();
			const rh:Number = sh / 2 * Math.random();

			targetPoint.x = rw < sw / 4 ? -rw : sw + rw / 4;
			targetPoint.y = rh < sh / 4 ? -rh : sh + rh / 4;
		}

		/**
		 * isNearTargetPoint
		 *
		 * @return true if near target point
		 */
		protected function isNearTargetPoint():Boolean {

			const nearTargetX:Boolean = Math.abs(targetPoint.x - x) < NEAR_DISTANCE;
			const nearTargetY:Boolean = Math.abs(targetPoint.y - y) < NEAR_DISTANCE;

			return nearTargetX && nearTargetY;
		}

		/**
		 * toString
		 *
		 * @return
		 */
		override public function toString():String 
		{
			const tx:String = targetPoint ? int(targetPoint.x).toString() : "[null]";
			const ty:String = targetPoint ? int(targetPoint.y).toString() : "[null]";
			
			return "[enemy] (" + tx + "," + tx + ") " + int(rotation) + " " + int(alpha * 100) / 100;
		}

		/**
		 * takeHit
		 * 
		 * @param   amount
		 * @return  true if dead
		 */
		public function takeHit(amount:uint):Boolean {

			if (amount >= health) {
				health = 0;
			}
			else {
				health -= amount;
			}

			return health == 0;
		}

		/**
		 * getScorePoints
		 */
		public function getScorePoints():uint {
			return 10 * health;
		}
	
		/**
		 * pickStart
		 */
		public function pickStart():void {
			x = 0;
			y = 0;
		}
	}
}
