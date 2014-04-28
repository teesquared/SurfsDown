package  
{
	/**
	 * Explosion
	 *
	 * @author Tony Tyson (teesquared@twistedwords.net)
	 */
	public class Debris extends GameSprite 
	{
		private var initialLifespan:uint = 0;

		/**
		 * Explosion
		 */
		public function Debris(color:uint, lifespan:uint, size:Number) {
			super();

			this.lifespan = lifespan;
			initialLifespan = lifespan;

			graphics.beginFill(color);
			graphics.drawCircle(0, 0, size);
			graphics.endFill();
		}

		/**
		 * update
		 */
		override protected function update():void 
		{
			super.update();

			alpha = lifespan / initialLifespan;
		}
	}

}