package
{
	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * YellowSubmarine
	 *
	 * @author Tony Tyson (teesquared@twistedwords.net)
	 */
	public class YellowSubmarine extends GameSprite
	{
		private var invulnerableCount:uint = 0;

		/**
		 * YellowSubmarine
		 */
		public function YellowSubmarine() {
			super();
		}

		/**
		 * init
		 *
		 * @param	e
		 */
		override protected function init(e:Event):void {
			super.init(e);
			
			maxX = SurfsDown.WIDTH - width;
			maxY = SurfsDown.HEIGHT - height;

			reset();
		}
	
		/**
		 * launch
		 * 
		 * @param	gameSprite
		 */
		public function launch(gameSprite:GameSprite):void {
			gameSprite.fire(x + turret.x, y + turret.y);
		}

		/**
		 * reset
		 *
		 * @param	x
		 * @param	y
		 */
		public function reset():void {
			invulnerableCount = 120;
			x = 256 - width / 2;
			y = 256 - height / 2;
			visible = true;
		}

		/**
		 * isInvulernable
		 *
		 * @return
		 */
		public function isInvulernable():Boolean {
			return invulnerableCount > 0;
		}

		/**
		 * update
		 */
		override protected function update():void 
		{
			super.update();

			if (invulnerableCount)
				--invulnerableCount;
		}

		/**
		 * determineMove
		 */
		override protected function determineMove():void {
			if (SurfsDown.gameActive)
				return;

			if (frameCounter % 120 == 0) {

				if (moveX == 0 && moveY == 0) {
					const a1:Number = 360 * Math.random() * Utils.DEGREES_TO_RADS;

					moveX = Math.cos(a1);
					moveY = Math.sin(a1);
				}
				else {
					const a2:Number = (135 + 90 * Math.random()) * Utils.DEGREES_TO_RADS;

					const c:Number = Math.cos(a2);
					const s:Number = Math.sin(a2);

					const d:Number = Math.sqrt(moveX * moveX + moveY * moveY);
					
					moveX /= d;
					moveY /= d;

					const nx:Number = moveX * c - moveY * s;
					const ny:Number = moveX * s + moveY * c;

					const d2:Number = 1; // + Math.random();

					moveX = nx * d2;
					moveY = ny * d2;
				}

				/*
				moveX = -0.5 + Math.random();
				moveY = -0.5 + Math.random();
				*/
			}
		}

		/**
		 * getBoundingBox
		 *
		 * @return
		 */
		override public function getBoundingBox():DisplayObject 
		{
			return boundingBox;
		}
	}
}
