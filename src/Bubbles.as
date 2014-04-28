package  {
	
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * Bubbles
	 *
	 * @author Tony Tyson (teesquared@twistedwords.net)
	 */
	public class Bubbles extends Sprite {
		
		private var fader:uint = 0;
		private var speed:Number = 0;

		/**
		 * Bubbles
		 */
		public function Bubbles() {
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		/**
		 * init
		 *
		 * @param	e
		 */
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, enterFrame);
			
			resetLocation();
			y += SurfsDown.HEIGHT * Math.random();
			speed = 3 * Math.random() + 1;
			fader = 360 * Math.random();
			scaleX = 0.1 + Math.random() * 2;
			scaleY = scaleX;
		}
		
		/**
		 * enterFrame
		 *
		 * @param	e
		 */
		private function enterFrame(e:Event):void {
			y -= speed;
			alpha = (1 + Math.cos(++fader / 45)) / 4;

			if (y < -height)
				resetLocation();
		}

		/**
		 * resetLocation
		 */
		private function resetLocation():void {
			x = -width / 2 + (SurfsDown.WIDTH + width) * Math.random();
			y = SurfsDown.HEIGHT;
		}
	}
}
