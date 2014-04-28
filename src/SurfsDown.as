package {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.system.fscommand;
	import flash.text.TextField;
	import flash.text.TextFormat;

	/**
	 * SurfsDown
	 *
	 * @author Tony Tyson (teesquared@twistedwords.net)
	 */
	public class SurfsDown extends Sprite {

		public static const WIDTH:Number = 512;
		public static const HEIGHT:Number = 512;

		public static var gameActive:Boolean = false;
		
		private var yellowSubmarine:YellowSubmarine = null;

		private var torpedo:Torpedo = null;

		private var enemies:Array = [];

		private var enemyLayer:Sprite = null;
		private var debrisLayer:Sprite = null;
		private var weaponLayer:Sprite = null;
		private var textLayer:Sprite = null;
		
		private var keys:Array = [];

		private var debugEnabled:Boolean = false;
		private var debugTextField:TextField = null;
		private var debugText:String = "";

		private var livesDisplay:TextField = null;
		private var scoreDisplay:TextField = null;
		private var depthDisplay:TextField = null;

		private var menuDisplay:TextField = null;
		private var endDisplay:TextField = null;

		private var lives:uint = 3;
		private var score:uint = 0;
		private var depth:uint = 0;

		private var frameCounter:uint = 0;
		private var deathCounter:uint = 0;
		private var anyKeyPressed:Boolean = false;

		private var updateFunction:Function = null;

		private var depthAlarmSound:Sound = new DepthAlarmSound() as Sound;
		private var fireTorpedoSound:Sound = new FireTorpedoSound() as Sound;
		private var sharkHitSound:Sound = new SharkHitSound() as Sound;
		private var shipExplosionSound:Sound = new ShipExplosionSound() as Sound;
		
		/**
		 * SurfsDown
		 */
		public function SurfsDown() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		/**
		 * init
		 *
		 * @param	e
		 */
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);

			/// @todo
			trace(this);

			addBubbles(10);

			enemyLayer = new Sprite();
			addChild(enemyLayer);

			weaponLayer = new Sprite();
			addChild(weaponLayer);

			createEnemyShark();

			yellowSubmarine = new YellowSubmarine();
			addChild(yellowSubmarine);

			torpedo = new Torpedo();
			torpedo.addEventListener(GameSprite.EVENT_OFFSCREEN, torpedoOffscreen);

			debrisLayer = new Sprite();
			addChild(debrisLayer);

			textLayer = new Sprite();
			addChild(textLayer);

			scoreDisplay = createTextField(0, 0, 256, 32);
			livesDisplay = createTextField(WIDTH - 128, 0, 128, 32);
			depthDisplay = createTextField(0, HEIGHT - 32, 256, 32); // WIDTH / 2 - 256 / 2
			
			updateGameDisplay();

			menuDisplay = createTextField(WIDTH / 2 - 64, HEIGHT / 2 - 64, 128, 128);
			
			endDisplay = createTextField(WIDTH, HEIGHT / 2 - 64, 288, 64, 64);
			endDisplay.text = "GAME OVER";

			addBubbles(10);
		
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);

			startMenu();

			addEventListener(Event.ENTER_FRAME, enterFrame);
		}

		/**
		 * startMenu
		 */
		private function startMenu():void {
			var menuText:String = "";

			menuText += "  PRESS  \n";
			menuText += " ANY KEY \n";
			menuText += "    TO   \n";
			menuText += "  START  \n";

			menuDisplay.text = menuText;
			menuDisplay.visible = true;
			endDisplay.visible = false;
			gameActive = false;

			yellowSubmarine.visible = true;

			updateFunction = updateMenu;
		}

		/**
		 * startGame
		 */
		private function startGame():void {
			lives = 3;
			score = 0;
			depth = 0;
			yellowSubmarine.reset();

			menuDisplay.visible = false;
			gameActive = true;
			deathCounter = 0;
			
			destroyEnemies();
			createEnemyShark();

			updateFunction = updateGame;
		}
		
		/**
		 * endGame
		 */
		private function endGame():void {
			gameActive = false;
			yellowSubmarine.visible = false;

			endDisplay.x = WIDTH;
			endDisplay.visible = true;

			updateFunction = updateEnd;
		}

		/**
		 * destroyEnemies
		 */
		private function destroyEnemies():void {
			for each (var enemy:Enemy in enemies) {
				enemyLayer.removeChild(enemy);
			}
			enemies.length = 0;
		}

		/**
		 * createEnemyShark
		 */
		private function createEnemyShark():void {

			var enemy:Enemy = null

			if (enemies.length >= 16) {
				// survival of the fitest
				enemy = enemies.shift();
				enemyLayer.removeChild(enemy);
				enemy = null;
			}

			if (depth <= 100) {
//				enemy = new SharkBoss();
				enemy = new Shark(1 + 1 * Math.random(), 2, 4);
			}
			else if (depth <= 1000) {
				enemy = new Shark(2 + 2 * Math.random(), 3, 4.5);
			}
			else if (depth <= 5000) {
				enemy = new Shark(2 + 3 * Math.random(), 4, 5);
			}
			else if (depth <= 10000) {
				enemy = new Shark(3 + 3 * Math.random(), 5, 5.5);
			}
			//else if (depth <= 15000) {
			//	enemy = new Shark(3 + 4 * Math.random(), 6, 6);
			//}
			else {
				enemy = new SharkBoss();
			}

			if (enemy) {
				enemyLayer.addChild(enemy);
				enemies.push(enemy);
			}
		}

		/**
		 * torpedoOffscreen
		 *
		 * @param	e
		 */
		private function torpedoOffscreen(e:Event):void 
		{
			weaponLayer.removeChild(torpedo);
		}
		
		/**
		 * debugPrint
		 *
		 * @param	text
		 */
		private function debugPrint():void {

			if (!debugEnabled)
				return;

			if (!debugTextField) {
				
				debugTextField = createTextField(0, HEIGHT - 128 - 32, WIDTH, 128);
				debugTextField.multiline = true;
			}

			debugTextField.text = debugText;
			debugText = "";
		}

		/**
		 * createTextFormat
		 *
		 * @return
		 */
		private function createTextField(x:Number = 0, y:Number = 0, width:Number = 0, height:Number = 0, fontSize:uint = 32):TextField {

			var textField:TextField = new TextField();
			textField.defaultTextFormat = new TextFormat("Times Square", fontSize, 0xFFFFFF);

			textField.x = x;
			textField.y = y;
			
			//textField.background = true;
			//textField.backgroundColor = 0x1F1F1F;
			
			if (width)
				textField.width = width;

			if (height)
				textField.height = height;

			textLayer.addChild(textField);

			return textField;
		}

		/**
		 * setDebugText
		 *
		 * @param	text
		 */
		private function setDebugText(text:String):void {
			debugText = text;
		}

		/**
		 * addDebugText
		 *
		 * @param	text
		 */
		private function addDebugText(text:String):void {
			debugText += text + "\n";
		}

		/**
		 * addBubbles
		 */
		private function addBubbles(n:uint):void {
			for (var i:uint = 0; i < n; ++i) {
				var bubbles:Bubbles = new Bubbles();
				addChild(bubbles);
			}
		}
		
		/**
		 * enterFrame
		 *
		 * @param	e
		 */
		private function enterFrame(e:Event):void {
			if (updateFunction != null)
				updateFunction();

			if (keys[27])
				quitGame();

			++frameCounter;

			anyKeyPressed = false;

			if (debugEnabled) {
				//addDebugText(enemy ? enemy.toString() : "[null]");
				debugKeys();
				debugPrint();
			}
		}

		/**
		 * updateEnd
		 */
		private function updateEnd():void {
			endDisplay.x -= 2;
			if (endDisplay.x <= -endDisplay.width)
				startMenu();
		}

		/**
		 * updateMenu
		 */
		private function updateMenu():void {
			if (frameCounter % 120 == 0)
				fireTorpedo();

			if (anyKeyPressed)
				startGame();
		}

		/**
		 * updateGame
		 */
		private function updateGame():void {

			if (deathCounter) {
				--deathCounter;

				if (deathCounter == 0) {
					yellowSubmarine.reset();
				}
				else {
					return;
				}
			}

			var moveX:Number = 0;
			var moveY:Number = 0;

			if (keys[37] || keys[65])
				moveX -= 1.5;

			if (keys[39] || keys[68])
				moveX += 1.5;

			if (keys[38] || keys[87])
				moveY -= 1;

			if (keys[40] || keys[83])
				moveY += 1;

			if (keys[13] || keys[32])
				fireTorpedo();
			
			yellowSubmarine.setMoveX(moveX);
			yellowSubmarine.setMoveY(moveY);

			checkCollision();
			
			if (++depth % 200 == 0)
				createEnemyShark();

			if (depth > 10000) {
				if (depth % 10 == 0) {
					depthDisplay.textColor = depthDisplay.textColor == 0xFFFFFF ? 0xFF0000 : 0xFFFFFF;
				}
				if (depth % 60 == 0) {
					depthAlarmSound.play();
				}
			}
			else {
				depthDisplay.textColor = 0xFFFFFF;
			}

			updateGameDisplay();
		}

		/**
		 * playerHit
		 */
		private function playerHit():void {

			--lives;

			yellowSubmarine.visible = false;
			createDebris(yellowSubmarine, 0xFF, 0xFF, 0x00, 64);
			shipExplosionSound.play();

			if (lives == 0) {
				endGame();
			}
			else {
				deathCounter = 120;
			}
		}

		/**
		 * checkCollision
		 */
		private function checkCollision():void {
			var alive:Array = [];

			for each (var enemy:Enemy in enemies) {

				if (yellowSubmarine.visible && !yellowSubmarine.isInvulernable() && yellowSubmarine.hitTestBoundBox(enemy)) {
					playerHit();
				}

				if (torpedo.active && torpedo.hitTestBoundBox(enemy)) {

					score += enemy.getScorePoints();

					weaponLayer.removeChild(torpedo);

					if (enemy.takeHit(1)) {
						enemyLayer.removeChild(enemy);
						createDebris(enemy, 0xFF, 0x00, 0x00, 64);
						sharkHitSound.play();
					}
					else {
						createDebris(enemy, 0x00, 0x66, 0xCC, 16);
						alive.push(enemy); // not dead yet
					}
				}
				else {
					alive.push(enemy);
				}
			}

			enemies = alive;
		}

		/**
		 * createDebris
		 *
		 * @param	source
		 */
		private function createDebris(source:GameSprite, r:uint, g:uint, b:uint, size:uint):void {

			for (var i:uint = 0; i < size; ++i) {

				const rand:Number = Math.random() * 0.8 + 0.2;

				const rr:uint = (r * rand) & 0xFF; 
				const rg:uint = (g * rand) & 0xFF; 
				const rb:uint = (b * rand) & 0xFF; 

				const debrisColor:uint = rr << 16 | rg << 8 | rb;

				var debris:Debris = new Debris(debrisColor, 30 + 15 * Math.random(), 2 + 4 * Math.random());
				
				var rect:Rectangle = source.getRect(this);

				debris.addEventListener(GameSprite.EVENT_DESTROYED, debrisDestroyed);
				debris.x = rect.x + rect.width / 2;
				debris.y = rect.y + rect.height / 2;
				debris.setMoveX(-0.5 + Math.random());
				debris.setMoveY(-0.5 + Math.random());
				debrisLayer.addChild(debris);
			}
		}
		
		/**
		 * debrisDestroyed
		 *
		 * @param	e
		 */
		private function debrisDestroyed(e:Event):void 
		{
			debrisLayer.removeChild(e.target as DisplayObject);
		}
		
		/**
		 * updateGameDisplay
		 */
		private function updateGameDisplay():void 
		{
			livesDisplay.text = "LIVES: " + lives;
			scoreDisplay.text = "SCORE: " + score;
			depthDisplay.text = "DEPTH: " + depth;
		}
		
		/**
		 * quitGame
		 */
		private function quitGame():void 
		{
			/// @todo
			fscommand("quit")
		}
		
		/**
		 * fireTorpedo
		 */
		private function fireTorpedo():void 
		{
			if (torpedo.active)
				return;

			if (gameActive)
				fireTorpedoSound.play();

			yellowSubmarine.launch(torpedo);

 			weaponLayer.addChild(torpedo);
		}

		/**
		 * debugKeys
		 */
		private function debugKeys():void {
			for (var k:String in keys) {
				if (keys[k]) {
					addDebugText("[DOWN] keyCode: " + k)
				}
			}
		}

		/**
		 * keyDown
		 *
		 * @param	e
		 */
		private function keyDown(e:KeyboardEvent):void {
			keys[e.keyCode] = true;
			anyKeyPressed = true;
		}

		/**
		 * keyUp
		 *
		 * @param	e
		 */
		private function keyUp(e:KeyboardEvent):void 
		{
			keys[e.keyCode] = false;
		}
		
	}
}
