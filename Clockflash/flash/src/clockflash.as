package {

	import flash.system.fscommand;
	import flash.external.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;	
	import flash.net.*;
	import flash.text.*;
	import flash.utils.ByteArray;
	

	public class clockflash extends Sprite {

		// Flex
		//[Embed(source = "back.jpg")] static private const backBD: Class;
		
		private var mp3: Sound;
		private var mp3Ch: SoundChannel;
		private var mp3Path: String;
		private var mp3Vol: Number;
	
		public var back: DisplayObject;
		public var txt: TextField = new TextField();
		public var clock: Loader = new Loader();
		public var over: Sprite = new Sprite();
		
		public var sW:int, sH:int;
		
		public function clockflash():void {
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}

		private function init(e:Event = null):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = 'TL';
			stage.scaleMode = 'noScale';
			
			addChilds();
	
			stage.addEventListener(Event.RESIZE, onResize);	
			onResize(null);
			
			addCallBackFunc('p2f_getSomeInfo', getSomeInfo);
			addCallBackFunc('p2f_getMP3Info', getMP3Info);
			addCallBackFunc('p2f_playMP3', playMP3);
			addCallBackFunc('p2f_stopMP3', stopMP3);
			addCallBackFunc('p2f_setVolume', setVolume);
			addCallBackFunc('p2f_setPos', setPos);
			addCallBackFunc('p2f_newText', newText);
			
		}
		
		private function addChilds():void {
			
			// Flex
			//back = addChild(new backBD());
			back = addChild(new Bitmap(new backBD(0,0)));			
			
			var f:TextFormat = new TextFormat('Consolas', 24, 0xff8800); 
			txt.defaultTextFormat = f;
			txt.text = 'text';
			txt.x = 40;
			addChild(txt);
			
			clock.load(new URLRequest('clock.swf'));
			addChild(clock);
			
			with (over.graphics) {
				beginFill(0, 0);
				drawRect(0,0,800,600);
			}
			addChild(over);
			
		}
		
		private function onResize(e:Event):void {
			
			sW = stage.stageWidth;
			sH = stage.stageHeight;
			
			back.width = sW;
			back.height = sH;
			
			clock.x = sW * 0.2;
			clock.y = sH * 0.2;
			clock.scaleX = clock.scaleY = sH / 300;
			
			over.width = sW;
			over.height = sH;
			
			txt.y = sH - 120;
			
		}
		
		private function addCallBackFunc(jsf:String, f:Function):void {
			
			if (ExternalInterface.available)
				ExternalInterface.addCallback(jsf, f);
			
		}
		
		public function getSomeInfo():void {
			
			fscommand('f2p_SomeInfo', stage.stageWidth + '¦' + stage.stageHeight + '¦' + over.mouseX + '¦' + over.mouseY);
			
		}

		public function getMP3Info():void {
			
			if (!mp3)
				return;
			
			var s:String = Math.floor(mp3.length / 1000) + '¦';
			s += Math.floor(mp3Ch.position / 1000) + '¦';
			s += Math.floor(mp3.bytesTotal) + '¦';
			s += Math.floor(mp3.bytesLoaded) + '¦';
			s += Math.floor(mp3Vol * 10) + '¦';
			
			var ba: ByteArray = new ByteArray();
			SoundMixer.computeSpectrum(ba, true);
			
			var pl:Number = 0, pr:Number = 0, f:Number;
			for (var i:int = 0; i < 255; i++ ) {
				f = ba.readFloat();
				pl = f > pl ? f : pl;
			}
			for (i = 0; i < 255; i++ ) {
				f = ba.readFloat();
				pr = f > pr ? f : pr;
			}
			
			s += Math.floor(pl / 0.01414) + '¦' + Math.floor(pr / 0.01414);

			fscommand('f2p_MP3Info', s);
			
		}

		public function playMP3(path:String, pos:Number = 0, vol:Number = -1):void {
			
			stopMP3();

			if (path != '') {
				mp3Path = path;
				mp3 = new Sound();
				mp3.load(new URLRequest(path));
				mp3Ch = mp3.play(pos, 1);
				mp3Ch.addEventListener(Event.SOUND_COMPLETE, function():void {
					fscommand('f2p_mp3Complete', '');
				});
			}
			
			setVolume(vol >= 0 ? vol : mp3Vol);
			
		}

		public function stopMP3():void {
	
			if (mp3 != null){
				mp3Ch.stop();
				try{
					mp3.close();
					mp3 = null;
				}catch(err:Error){}
			}
			
		}

		public function setVolume(vol:Number = 1):void {
			
			if (mp3 != null && vol != mp3Vol) {
				var trans: SoundTransform = new SoundTransform(vol, 0);
				mp3Ch.soundTransform = trans;
				mp3Vol = vol;
			}
			
		}

		public function setPos(pos:Number):void {
			
			if (mp3 != null)
				playMP3(mp3Path, pos * mp3.length * mp3.bytesLoaded / mp3.bytesTotal);
			
		}
		

		public function newText(t:String):void {
			
			txt.text = t;
			txt.autoSize = 'left';
			
		}		

	}

}