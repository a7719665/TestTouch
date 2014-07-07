package utils
{
	import flash.debugger.enterDebugger;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;

	public class SportsUtil
	{
		public static var comFunObj:Dictionary = new Dictionary(); //可用数组,也可用对象

 		public function SportsUtil()
		{
		}
		/**上*/
		public static function JumpUp($dis:SportRole,call:Function):void{
			if(!$dis.inAir){
				comFunObj[$dis] = call;
 				EnterframeManager.getInstance().pushItToRender($dis,StartJumpUp);
			}
		}
		public static function StartJumpUp($dis:SportRole):void{
			if(!$dis.inAir){
				$dis.inAir=true;
				$dis.initY = $dis.y;
 				$dis.velocity = -$dis.initVelocityY;
			}
 			$dis.velocity += $dis.gravity;
			$dis.y += $dis.velocity;
			$dis.inAir = true;
			
			checkDisHitGrid($dis);
		}
	

		/**左上*/
		public static function JumpLeftUp($dis:SportRole,call:Function):void{
			if(!$dis.inAir){
				comFunObj[$dis] = call;
				EnterframeManager.getInstance().pushItToRender($dis,StartJumpLeftUp);
			}
		}
		
		public static function StartJumpLeftUp($dis:SportRole):void{
			if(!$dis.inAir){
				$dis.inAir=true;
 				$dis.initY = $dis.y;
				$dis.velocity = -$dis.initVelocityY;
 			}
			
			$dis.velocity += $dis.gravity;
			$dis.y += $dis.velocity;
			$dis.x -= $dis.initJumpVelocityX;
			$dis.inAir = true;
			
			checkDisHitGrid($dis);
		}

		/**左下*/
		public static function JumpLeftDown($dis:SportRole,call:Function):void{
			if(!$dis.inAir){
				comFunObj[$dis] = call;
				EnterframeManager.getInstance().pushItToRender($dis,StartJumpLeftDown);
			}
		}
		
		public static function StartJumpLeftDown($dis:SportRole):void{
			if(!$dis.inAir){
				$dis.inAir=true;
 				$dis.initY = $dis.y;
				$dis.velocity = $dis.zeroVelocityY;
 			}
			
			$dis.velocity += $dis.gravity;
			$dis.y += $dis.velocity;
			$dis.x -= $dis.initWalkVelocityX;
			$dis.inAir = true;
			
			checkDisHitGrid($dis);
		}
		/**右下*/
		public static function JumpRightDown($dis:SportRole,call:Function):void{
			if(!$dis.inAir){
				comFunObj[$dis] = call;
				EnterframeManager.getInstance().pushItToRender($dis,StartJumpRightDown);
			}
		}
		
		public static function StartJumpRightDown($dis:SportRole):void{
			if(!$dis.inAir){
				$dis.inAir=true;
 				$dis.initY = $dis.y;
				$dis.velocity = $dis.zeroVelocityY;
 			}
			
			$dis.velocity += $dis.gravity;
			$dis.y += $dis.velocity;
			$dis.x += $dis.initWalkVelocityX;
			$dis.inAir = true;
			
			checkDisHitGrid($dis);
		}
		
		/**右上*/
		public static function JumpRightUp($dis:SportRole,call:Function):void{
			if(!$dis.inAir){
 				comFunObj[$dis] = call;
				EnterframeManager.getInstance().pushItToRender($dis,StartJumpRightUp);
			}
		}
		
		public static function StartJumpRightUp($dis:SportRole):void{
			if(!$dis.inAir){
 				$dis.initY = $dis.y;
				$dis.inAir=true;
				$dis.velocity = -$dis.initVelocityY;
 			}
 			$dis.velocity += $dis.gravity;
			$dis.y += $dis.velocity;
			$dis.x += $dis.initJumpVelocityX;
			$dis.inAir = true;
			
			checkDisHitGrid($dis);
		}
		
		
		
		public static function checkDisHitGrid($dis:SportRole):void{
			if($dis.inAir && $dis.velocity >= 0){
//				var x:int = $dis.x/Grid._cellSize;
//				var y:int = $dis.y/Grid._cellSize; 
				var grid:Grid = MyPathFinding.mainGrid;
				var node:Node = grid.getNodeByXy($dis.x,$dis.y);
				if(node==null)
					return;
				if(node.walkable ==  AStar.CANWALK){
					$dis.x = node.x * Grid._cellSize + Grid._cellSize / 2;
					$dis.y = node.y * Grid._cellSize + Grid._cellSize / 2;
					clearAllStatus($dis);
				}
			}
			tiaozhenX($dis);
		}
		private static function clearAllStatus($dis:SportRole):void{
			$dis.inAir = false;
			EnterframeManager.getInstance().deleteOne($dis);
			(comFunObj[$dis] as Function).apply(null,[$dis]);
			delete comFunObj[$dis];
		}
		
		public static function tiaozhenX($dis:SportRole):Boolean{
			if(($dis.x + $dis.width/2) >= MyPathFinding.swfWidth){
				$dis.x = MyPathFinding.swfWidth - $dis.width/2;
				return true;
			}
			return false;
		}
	}
}