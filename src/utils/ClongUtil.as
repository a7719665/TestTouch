package utils
{
	import avmplus.getQualifiedClassName;
	
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;

	public class ClongUtil
	{
		public function ClongUtil()
		{
			
		}
		/*有两种，一种是浅拷贝，还有就是深拷贝。浅拷贝拷贝只是引用，会影响被拷贝的数据。例如数组的slice方法返回的是一个数组的浅拷贝，通过改变数组中的东西会改变原被拷贝数据。
		深拷贝复制的源对象的二进制数据，所以不会影响到原数据的属性和方法。
		
		对象克隆可以复制出一个和已存在对象相同的对象，并且两个对象没有关联。ActionScript 3.0中克隆对象使用的是ByteArray类。方法很简单，如下：*/
		public function clone(obj:Object):* {
			var copier:ByteArray = new ByteArray();
			copier.writeObject(obj);
			copier.position = 0;
			return copier.readObject();
		}
		/*由于复制后返回的类型已不再确定了，所以如果是自定义类，是无法强制转换的，会出现转换错误。clone方法可以对对象实例进行深度拷贝，这些对象包括系统内置的对象实例、自定义普通对象实例、自定义动态对象实例等等。
		但是有值得注意的地方，这个方法可以深度拷贝你的对象，但是它不会一同拷贝类的类型定义。所以，如果查需要拷贝一个自定义类型实例时，拷贝出的对象将不再是自定义类型，而是Object，因此在拷贝自定义类型对象的实例时，不要进行强制类型转换，否则将会得不到想要的结果。看看下面的例子。
		var p:MyClass=new MyClass();//自定义的类
		var myClass:*=clone(p);//复制
		
		在看一种复制方法：*/
		/*   
		*   深度拷贝，最好用于普通对象上，不要用于自定义类上
		*   obj: 要拷贝的对象
		*   return ：返回obj的深度拷贝
		*/
		public static function clone(object:Object):Object{  
			var qClassName:String = getQualifiedClassName(object);  
			var objectType:Class = getDefinitionByName(qClassName) as Class;  
			registerClassAlias(qClassName, objectType);//这里
			var copier : ByteArray = new ByteArray();  
			copier.writeObject(object);  
			copier.position = 0;  
			return copier.readObject();  
		}
		/*			这个方法可以获取到相应的类型，但对于DisplayObject类型对象无法复制完全。对于soundTransform和transform是无法转换成功的。所以
		DisplayObject不要用这个方法。
		
		下面是针对DisplayObject使用的复制方法，复制后虽然有一点差异。数据复制的不是很完美，有可能width属性小1.2或者旋转角度大0.54,当着问题不大。*/
		
		/*
		*    影片剪辑的复制，只要是DisplayObject都可以
		*    target ：要复制的影片剪辑
		*     @param autoAdd if true, adds the duplicate to the display list
		*      in which target was located
		*    注意：Flash 9会有bug
		*/
		public static function duplicateDisplayObject(target:DisplayObject, autoAdd:Boolean = false):DisplayObject {
			// create duplicate
			var targetClass:Class = Object(target).constructor;
			var duplicate:DisplayObject = new targetClass();
			
			// duplicate properties
			duplicate.transform = target.transform;
			duplicate.filters = target.filters;
			duplicate.cacheAsBitmap = target.cacheAsBitmap;
			duplicate.opaqueBackground = target.opaqueBackground;
			if (target.scale9Grid) {
				var rect:Rectangle = target.scale9Grid;
				// Flash 9 bug where returned scale9Grid is 20x larger than assigned
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				duplicate.scale9Grid = rect;
			}
			
			// add to target parent's display list
			// if autoAdd was provided as true
			if (autoAdd && target.parent) {
				target.parent.addChild(duplicate);
			}
			return duplicate;
		}
	}
}