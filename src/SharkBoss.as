package {

	/**
	 * SharkBoss
	 *
	 * @author Tony Tyson (teesquared@twistedwords.net)
	 */
	public class SharkBoss extends Shark {

		/**
		 * SharkBoss
		 */
		public function SharkBoss() {
			super(10, 30, 4);
		}

		/**
		 * update
		 */
		override protected function update():void 
		{
			super.update();

			//lazerBeam.visible = true;
		}

		/**
		 * pickTargetPoint
		 */
		override protected function pickTargetPoint():void {

			const sw:Number = SurfsDown.WIDTH;
			const sh:Number = SurfsDown.HEIGHT;

			switch (uint(Math.random() * 4))
			{
				case 0:
					x = -width;
					y = -height / 2 + Math.random() * sh;
					targetPoint.x = sw + width;
					targetPoint.y = y;
					//moveX = 1;
					//moveY = 0;
					break;
				case 1:
					x = sw + width;
					y = -height / 2 + Math.random() * sh;
					targetPoint.x = -width;
					targetPoint.y = y;
					//moveX = -1;
					//moveY = 0;
					break;
				case 2:
					x = -width / 2 + Math.random() * sw;
					y = sh + height;
					targetPoint.x = x;
					targetPoint.y = -height;
					//moveX = 0;
					//moveY = -1;
					break;
				default:
					x = -width / 2 + Math.random() * sw;
					y = -height;
					targetPoint.x = x;
					targetPoint.y = sh + height;
					//moveX = 0;
					//moveY = 1;
					break;
			}
		}

		/**
		 * pickStart
		 */
		override public function pickStart():void {
		}
	}
}
