package  
{
	import flash.display.DisplayObject;

	/**
	 * Shark
	 *
	 * @author Tony Tyson (teesquared@twistedwords.net)
	 */
	public class Shark extends Enemy 
	{
		/**
		 * Shark
		 */
		public function Shark(scale:Number, health:Number, speed:Number) {
			super();

			scaleX = scale;
			scaleY = scale;

			this.health = health;
			this.speed = speed;

			lazerBeam.scaleY = 1 / scaleX;
		}

		/**
		 * update
		 */
		override protected function update():void 
		{
			super.update();

			lazerBeam.visible = Math.random() < 0.5;
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

		/**
		 * pickStart
		 */
		override public function pickStart():void 
		{
			const sw:Number = SurfsDown.WIDTH;
			const sh:Number = SurfsDown.HEIGHT;

			switch (uint(Math.random() * 4))
			{
				case 0:
					x = -width;
					y = -height;
					break;
				case 1:
					x = sw + width;
					y = -height;
					break;
				case 2:
					x = -width;
					y = sh + height;
					break;
				default:
					x = sw + width;
					y = sh + height;
					break;
			}
		}
	}
}
