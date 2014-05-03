package {

	/**
	 * SharkProp
	 *
	 * @author Tony Tyson (teesquared@twistedwords.net)
	 */
	public class SharkProp extends SharkBoss {

		/**
		 * SharkProp
		 */
		public function SharkProp() {
			super();
		}

		/**
		 * setPosition
		 *
		 * @param	x
		 * @param	y
		 * @param	dir
		 */
		public function setPosition(x:Number, y:Number, rot:Number):void {
			this.x = x;
			this.y = y;
			rotation = rot;
		}

		/**
		 * update
		 */
		override protected function update():void {
		}

		/**
		 * pickStart
		 */
		override public function pickStart():void {
		}

		/**
		 * pickTargetPoint
		 */
		override protected function pickTargetPoint():void {
		}
	}
}
