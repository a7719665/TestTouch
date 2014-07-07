package game.logic
{
	import com.components.NokDialog;
	import com.flashandmath.dg.GUI.GradientSwatch;
	import com.flashandmath.dg.bitmapUtilities.BitmapSaver;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import morn.core.components.Button;

	public class SmoothDraw extends NokDialog
	{
		private var lineLayer:Sprite;
		private var lastSmoothedMouseX:Number;
		private var lastSmoothedMouseY:Number;
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var lastThickness:Number;
		private var lastRotation:Number;
		private var lineColor:uint;
		private var lineThickness:Number;
		private var lineRotation:Number;
		private var L0Sin0:Number;
		private var L0Cos0:Number;
		private var L1Sin1:Number;
		private var L1Cos1:Number;
		private var sin0:Number;
		private var cos0:Number;
		private var sin1:Number;
		private var cos1:Number;
		private var dx:Number;
		private var dy:Number;
		private var dist:Number;
		private var targetLineThickness:Number;
		private var colorLevel:Number;
		private var targetColorLevel:Number;
		private var smoothedMouseX:Number;
		private var smoothedMouseY:Number;
		private var tipLayer:Sprite;
		private var boardBitmap:Bitmap;
		public var boardBitmapData:BitmapData;
		private var bitmapHolder:Sprite;
		private var boardWidth:Number;
		private var boardHeight:Number;
		private var smoothingFactor:Number;
		private var mouseMoved:Boolean;
		private var dotRadius:Number;
		private var startX:Number;
		private var startY:Number;
		private var undoStack:Vector.<BitmapData>;
		private var minThickness:Number;
		private var thicknessFactor:Number;
		private var mouseChangeVectorX:Number;
		private var mouseChangeVectorY:Number;
		private var lastMouseChangeVectorX:Number;
		private var lastMouseChangeVectorY:Number;
		
		private var thicknessSmoothingFactor:Number;
		
		private var bitmapSaver:BitmapSaver;
		
		private var controlVecX:Number;
		private var controlVecY:Number;
		private var controlX1:Number;
		private var controlY1:Number;
		private var controlX2:Number;
		private var controlY2:Number;
		
		private var tipTaperFactor:Number;
		
		private var numUndoLevels:Number;
		
		private var controlPanel:Sprite;
		private var swatches:Vector.<GradientSwatch>;
		private var swatchColors:Vector.<uint>;
		
		private var paintColorR1:Number;
		private var paintColorG1:Number;
		private var paintColorB1:Number;
		private var paintColorR2:Number;
		private var paintColorG2:Number;
		private var paintColorB2:Number;
		
		private var red:Number;
		private var green:Number;
		private var blue:Number;
		
		private var colorChangeRate:Number;
		
		private var panelColor:uint;
		
		private var boardMask:Sprite;
		public function SmoothDraw()
		{
			
			////
			
			//Setting the following NO_SCALE parameter helps avoid strange artifacts
			//in the displayed bitmaps caused by repositioning of the swf within the html page.
			this.addEL(this,Event.ADDED_TO_STAGE,addToStage);
		}
		private function addToStage(evet:Event):void {
			stage.scaleMode=StageScaleMode.NO_SCALE;
			
			init();
		}
		/*
		
		By Dan Gries
		www.flashandmath.com
		dan@flashandmath.com
		
		*/
		
		
		
		
		
		
		////
		
		private function init():void {
			
			boardWidth = 256;
			boardHeight = 100;
			
			minThickness = 0.2;
			thicknessFactor = 0.25;
			
			smoothingFactor = 0.3;  //Should be set to something between 0 and 1.  Higher numbers mean less smoothing.
			thicknessSmoothingFactor = 0.3;
			
			dotRadius = 2; //radius for drawn dot if there is no mouse movement between mouse down and mouse up.
			
			tipTaperFactor = 0.8;
			
			numUndoLevels = 10;
			
			colorChangeRate = 0.05;
			
			panelColor = 0xAAAAAA;
			
			paintColorR1 = 16;
			paintColorG1 = 0;
			paintColorB1 = 0;
			paintColorR2 = 128;
			paintColorG2 = 0;
			paintColorB2 = 0;
			
			swatchColors = Vector.<uint>([0x100000, 0x800000,
				darkenColor(0xA24F31,0.5), 0xA24F31,
				darkenColor(0x906000,0.33), 0x906000,
				darkenColor(0xB48535,0.5), 0xB48535,
				darkenColor(0x938E60,0.75),0x938E60,
				darkenColor(0x6F7D4F,0.4),0x6F7D4F,
				0x000000, 0x226600,
				darkenColor(0x8FAD81, 0.75), 0x8FAD81,
				0x000000, 0x005077,								  
				darkenColor(0x4F848A,0.5),0x4F848A,
				darkenColor(0x646077,0.5),0x646077,
				darkenColor(0x784B67,0.4),0x784B67,
				darkenColor(0x9A659A, 0.4), 0x9A659A,
				0x000000, 0x606060,
				0x000000, 0x000000,
				0xD0D0D0, 0xFFFFFF]);
			swatches = new Vector.<GradientSwatch>;
			
			boardBitmapData = new BitmapData(boardWidth, boardHeight, false);
			boardBitmap = new Bitmap(boardBitmapData);
			
			
			//The undo buffer will hold the previous drawing.
			//If we want more levels of undo, we would have to record several undo buffers.  We only use one
			//here for simplicity.
			undoStack = new Vector.<BitmapData>;
			bitmapHolder = new Sprite();
			lineLayer = new Sprite();
			
			boardMask = new Sprite();
			boardMask.graphics.beginFill(0xFF0000);
			boardMask.graphics.drawRect(0,0,boardWidth,boardHeight);
			boardMask.graphics.endFill();
			boardMask.visible=false;
			drawBackground();
			
			/*
			The tipLayer holds the tip portion of the line.
			Because of the smoothing technique we are using, while the user is drawing the drawn line will not
			extend all the way from the last position to the current mouse position.  We use a small 'tip' to 
			complete this line all the way to the current mouse position.
			*/
			tipLayer = new Sprite();
			tipLayer.mouseEnabled = false;
			
			/*
			Bitmaps cannot receive mouse events.  so we add it to a holder sprite.
			*/
			this.addChild(bitmapHolder);
			bitmapHolder.x = 5;
			bitmapHolder.y = 5;
			bitmapHolder.addChild(boardBitmap);
			bitmapHolder.addChild(tipLayer);
			bitmapHolder.addChild(boardMask);
			bitmapHolder.mask = boardMask;
			
			//We add the panel at the bottom which will hold color swatches
			controlPanel = new Sprite();
			controlPanel.graphics.beginFill(panelColor);
			controlPanel.graphics.drawRect(0, 0, boardWidth, 40);
			controlPanel.graphics.endFill();
			controlPanel.x = bitmapHolder.x;
			controlPanel.y = bitmapHolder.y + boardHeight+2;
			this.addChild(controlPanel);
			createSwatches();
			
			var btnErase:Button = new Button("png.comp.btn_yellow","重画");
			btnErase.x = 180;
			btnErase.y = boardHeight+10;
			btnErase.addEventListener(MouseEvent.CLICK, erase);
			this.addChild(btnErase);
			
			var btnUndo:Button = new Button("png.comp.btn_yellow","撤销");
			btnUndo.x = 100;
			btnUndo.y = boardHeight+10;
			btnUndo.addEventListener(MouseEvent.CLICK, undoButtonHandler);
			this.addChild(btnUndo);
			
			var btnExport:Button = new Button("png.comp.btn_yellow","导出");
			btnExport.x = 20;
			btnExport.y = boardHeight+10;
			btnExport.addEventListener(MouseEvent.CLICK, exportHandler);
			this.addChild(btnExport);
			
			bitmapSaver = new BitmapSaver(boardBitmapData);
			bitmapSaver.x = 0.5*(boardWidth - bitmapSaver.width);
			bitmapSaver.y = 0.5*(boardHeight - bitmapSaver.height);
			
			bitmapHolder.addEventListener(MouseEvent.MOUSE_DOWN, startDraw);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
		}
		
		private function createSwatches():void {
			var swatchLength = Math.floor(0.8*controlPanel.height);
			var space:Number = 5;
			for (var i:Number = 0; i< swatchColors.length; i=i+2) {
				var thisSwatch:GradientSwatch = new GradientSwatch(swatchColors[i], swatchColors[i+1], 0.75*swatchLength, swatchLength);
				thisSwatch.x = (space + 0.75*swatchLength)*(i+1)/2;
				thisSwatch.y = controlPanel.height/2;
				controlPanel.addChild(thisSwatch);
				swatches.push(thisSwatch);
				thisSwatch.addEventListener(MouseEvent.CLICK, swatchClickHandler);
				thisSwatch.visible=false;
			}
		}
		
		private function swatchClickHandler(evt:MouseEvent):void {
			var thisSwatch = evt.currentTarget;
			paintColorR1 = thisSwatch.red1;
			paintColorG1 = thisSwatch.green1;
			paintColorB1 = thisSwatch.blue1;
			paintColorR2 = thisSwatch.red2;
			paintColorG2 = thisSwatch.green2;
			paintColorB2 = thisSwatch.blue2;
		}
		
		private function startDraw(evt:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_UP, stopDraw);
			
			startX = lastMouseX = smoothedMouseX = lastSmoothedMouseX = bitmapHolder.mouseX;
			startY = lastMouseY = smoothedMouseY = lastSmoothedMouseY = bitmapHolder.mouseY;
			lastThickness = 0;
			lastRotation = Math.PI/2;
			colorLevel = 0;
			lastMouseChangeVectorX = 0;
			lastMouseChangeVectorY = 0;
			
			//We will keep track of whether the mouse moves in between a mouse down and a mouse up.  If not,
			//a small dot will be drawn.
			mouseMoved = false;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, drawLine);
			//this.addEventListener(Event.ENTER_FRAME, drawLine);
		}
		
		private function drawLine(evt:MouseEvent):void {
			mouseMoved = true;
			
			lineLayer.graphics.clear();
			
			mouseChangeVectorX = bitmapHolder.mouseX - lastMouseX;
			mouseChangeVectorY = bitmapHolder.mouseY - lastMouseY;
			
			
			//Cusp detection - if the mouse movement is more than 90 degrees
			//from the last motion, we will draw all the way out to the last
			//mouse position before proceeding.  We handle this by drawing the
			//previous tipLayer, and resetting the last smoothed mouse position
			//to the last actual mouse position.
			//We use a dot product to determine whether the mouse movement is
			//more than 90 degrees from the last motion.
			if (mouseChangeVectorX*lastMouseChangeVectorX + mouseChangeVectorY*lastMouseChangeVectorY < 0) {
				boardBitmapData.draw(tipLayer);
				smoothedMouseX = lastSmoothedMouseX = lastMouseX;
				smoothedMouseY = lastSmoothedMouseY = lastMouseY;
				lastRotation += Math.PI;
				lastThickness = tipTaperFactor*lastThickness;
			}
			
			
			//We smooth out the mouse position.  The drawn line will not extend to the current mouse position; instead
			//it will be drawn only a portion of the way towards the current mouse position.  This creates a nice
			//smoothing effect.
			smoothedMouseX = smoothedMouseX + smoothingFactor*(bitmapHolder.mouseX - smoothedMouseX);
			smoothedMouseY = smoothedMouseY + smoothingFactor*(bitmapHolder.mouseY - smoothedMouseY);
			
			//We determine how far the mouse moved since the last position.  We use this distance to change
			//the thickness and brightness of the line.
			dx = smoothedMouseX - lastSmoothedMouseX;
			dy = smoothedMouseY - lastSmoothedMouseY;
			dist = Math.sqrt(dx*dx + dy*dy);
			
			if (dist != 0) {
				lineRotation = Math.PI/2 + Math.atan2(dy,dx);
			}
			else {
				lineRotation = 0;
			}
			
			//We use a similar smoothing technique to change the thickness of the line, so that it doesn't
			//change too abruptly.
			targetLineThickness = minThickness+thicknessFactor*dist;
			lineThickness = lastThickness + thicknessSmoothingFactor*(targetLineThickness - lastThickness);
			
			/*
			The "line" being drawn is actually composed of filled in shapes.  This is what allows
			us to create a varying thickness of the line.
			*/
			sin0 = Math.sin(lastRotation);
			cos0 = Math.cos(lastRotation);
			sin1 = Math.sin(lineRotation);
			cos1 = Math.cos(lineRotation);
			L0Sin0 = lastThickness*sin0;
			L0Cos0 = lastThickness*cos0;
			L1Sin1 = lineThickness*sin1;
			L1Cos1 = lineThickness*cos1;
			targetColorLevel = Math.min(1,colorChangeRate*dist);
			colorLevel = colorLevel + 0.2*(targetColorLevel - colorLevel);
			
			red = paintColorR1 + colorLevel*(paintColorR2 - paintColorR1);
			green = paintColorG1 + colorLevel*(paintColorG2  - paintColorG1);
			blue = paintColorB1 + colorLevel*(paintColorB2 - paintColorB1);
			
			lineColor = (red << 16) | (green << 8) | (blue);
			
			controlVecX = 0.33*dist*sin0;
			controlVecY = -0.33*dist*cos0;
			controlX1 = lastSmoothedMouseX + L0Cos0 + controlVecX;
			controlY1 = lastSmoothedMouseY + L0Sin0 + controlVecY;
			controlX2 = lastSmoothedMouseX - L0Cos0 + controlVecX;
			controlY2 = lastSmoothedMouseY - L0Sin0 + controlVecY;
			
			lineLayer.graphics.lineStyle(1,lineColor);
			lineLayer.graphics.beginFill(lineColor);
			lineLayer.graphics.moveTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
			lineLayer.graphics.curveTo(controlX1,controlY1,smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
			lineLayer.graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
			lineLayer.graphics.curveTo(controlX2, controlY2, lastSmoothedMouseX - L0Cos0, lastSmoothedMouseY - L0Sin0);
			lineLayer.graphics.lineTo(lastSmoothedMouseX + L0Cos0, lastSmoothedMouseY + L0Sin0);
			lineLayer.graphics.endFill();
			boardBitmapData.draw(lineLayer);
			
			//We draw the tip, which completes the line from the smoothed mouse position to the actual mouse position.
			//We won't actually add this to the drawn bitmap until a mouse up completes the drawing of the current line.
			
			//round tip:
			var taperThickness:Number = tipTaperFactor*lineThickness;
			tipLayer.graphics.clear();
			tipLayer.graphics.beginFill(lineColor);
			tipLayer.graphics.drawEllipse(bitmapHolder.mouseX - taperThickness, bitmapHolder.mouseY - taperThickness, 2*taperThickness, 2*taperThickness);
			tipLayer.graphics.endFill();
			//quad segment
			tipLayer.graphics.lineStyle(1,lineColor);
			tipLayer.graphics.beginFill(lineColor);
			tipLayer.graphics.moveTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
			tipLayer.graphics.lineTo(bitmapHolder.mouseX + tipTaperFactor*L1Cos1, bitmapHolder.mouseY + tipTaperFactor*L1Sin1);
			tipLayer.graphics.lineTo(bitmapHolder.mouseX - tipTaperFactor*L1Cos1, bitmapHolder.mouseY - tipTaperFactor*L1Sin1);
			tipLayer.graphics.lineTo(smoothedMouseX - L1Cos1, smoothedMouseY - L1Sin1);
			tipLayer.graphics.lineTo(smoothedMouseX + L1Cos1, smoothedMouseY + L1Sin1);
			tipLayer.graphics.endFill();
			
			lastSmoothedMouseX = smoothedMouseX;
			lastSmoothedMouseY = smoothedMouseY;
			lastRotation = lineRotation;
			lastThickness = lineThickness;
			lastMouseChangeVectorX = mouseChangeVectorX;
			lastMouseChangeVectorY = mouseChangeVectorY;
			lastMouseX = bitmapHolder.mouseX;
			lastMouseY = bitmapHolder.mouseY;
			
			evt.updateAfterEvent();
			
		}
		
		private function stopDraw(evt:MouseEvent):void {
			//If the mouse didn't move, we will draw just a dot.  Its size will be randomized.
			if (!mouseMoved) {
				var randRadius = dotRadius*(0.75+0.75*Math.random());
				var dotColor:uint = (paintColorR1 << 16) | (paintColorG1 << 8) | (paintColorB1);
				var dot:Sprite = new Sprite();
				dot.graphics.beginFill(dotColor)
				dot.graphics.drawEllipse(startX - randRadius, startY - randRadius, 2*randRadius, 2*randRadius);
				dot.graphics.endFill();
				boardBitmapData.draw(dot);
			}
			
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, drawLine);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopDraw);
			
			//We add the tipLayer to complete the line all the way to the current mouse position:
			boardBitmapData.draw(tipLayer);
			
			//record undo bitmap and add to undo stack
			var undoBuffer:BitmapData = new BitmapData(boardWidth, boardHeight, false);
			undoBuffer.copyPixels(boardBitmapData,undoBuffer.rect,new Point(0,0));
			undoStack.push(undoBuffer);
			if (undoStack.length > numUndoLevels + 1) {
				undoStack.splice(0,1);
			}
			
		}
		
		private function erase(evt:MouseEvent):void {
			tipLayer.graphics.clear();
			drawBackground();
		}
		
		private 	function drawBackground():void {
			//We draw a background with a very subtle gradient effect so that the canvas darkens towards the edges.
			var gradMat:Matrix = new Matrix();
			gradMat.createGradientBox(700,500,0,0,0);
			var bg:Sprite = new Sprite();
			bg.graphics.beginGradientFill("radial",[0xDDD0AA,0xC6B689],[1,1],[1,255],gradMat);
			bg.graphics.drawRect(0,0,700,500);
			bg.graphics.endFill();
			boardBitmapData.draw(bg);
			
			//We clear out the undo buffer with a copy of just a blank background:
			undoStack = new Vector.<BitmapData>;
			var undoBuffer:BitmapData = new BitmapData(boardWidth, boardHeight, false);
			undoBuffer.copyPixels(boardBitmapData,undoBuffer.rect,new Point(0,0));
			undoStack.push(undoBuffer);
		}
		
		private function undoButtonHandler(evt:MouseEvent):void {
			undo();
		}
		
		private function keyDownListener(evt:KeyboardEvent):void {
			//Listening for Z, which will be a keyboard shortcut for undo.
			if ((evt.keyCode == 90)) {
				undo();
			}
		}
		
		private function undo():void {
			if (undoStack.length > 1) {
				boardBitmapData.copyPixels(undoStack[undoStack.length - 2],boardBitmapData.rect,new Point(0,0));
				undoStack.splice(undoStack.length - 1, 1);
			}
			tipLayer.graphics.clear();
		}
		
		//this function assists with creating colors for the gradients.
		private function darkenColor(c:uint, factor:Number):uint {
			var r:Number = (c >> 16);
			var g:Number = (c >> 8) & 0xFF;
			var b:Number = c & 0xFF;
			
			var newRed:Number = Math.min(255, r*factor);
			var newGreen:Number = Math.min(255, g*factor);
			var newBlue:Number = Math.min(255, b*factor);
			
			return (newRed << 16) | (newGreen << 8) | (newBlue);
		}
		
		private function exportHandler(evt:MouseEvent):void {
			this.addChild(bitmapSaver);
			bitmapSaver.addEventListener(BitmapSaver.BUTTON_CLICKED, closeWindow);
		}
		
		private function closeWindow(evt:Event):void {
			this.removeChild(bitmapSaver);
			bitmapSaver.removeEventListener(BitmapSaver.BUTTON_CLICKED, closeWindow);
		}

	}
}