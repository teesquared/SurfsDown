package  
{
	/**
	 * Torpedo
	 *
	 * @author Tony Tyson (teesquared@twistedwords.net)
	 */
	public class Torpedo extends GameSprite 
	{
		/**
		 * Torpedo
		 */
		public function Torpedo() {
			super();
		}

		/**
		 * fire
		 */
		public override function fire(x:Number, y:Number):void {
			this.x = x;
			this.y = y;

			moveY = 2;
		}
	}
}
