package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.describeType;
	
	public class ClassCreationTest extends Sprite
	{
		public function ClassCreationTest()
		{
			PairClassGenerator.getPairClass(Point, onClassReady);
			PairClassGenerator.getPairClass(Rectangle, onClassReady);
		}

		private var _readyClasses:uint = 0;
		private function onClassReady(clazz:Class):void
		{
			_readyClasses++;
			
			if (_readyClasses < 2)
			{
				return;
			}
			
			const p0:Point = new Point(0, 3);
			const p1:Point = new Point(4, 0);
			const pointPair:Object = makePair(p0, p1);
			trace(describeType(pointPair));
			trace(pointPair);
			trace(pointPair.first);
			trace(pointPair.second);
			
			trace();
			
			const rect0:Rectangle = new Rectangle(0, 0, 100, 100);
			const rect1:Rectangle = new Rectangle(50, 50, 150, 150);
			const rectPair:Object = makePair(rect0, rect1);
			trace(describeType(rectPair));
			trace(rectPair);
			trace(rectPair.first);
			trace(rectPair.second);		}
		
		private function makePair(x:*, y:*):Object
		{
			const typeX:Class = (x as Object).constructor;
			const typeY:Class = (y as Object).constructor;
			if (typeX != typeY)
			{
				trace("makePair: parameters are of different types");
				return null;
			}
			
			const clazz:Class = PairClassGenerator.pairClass(typeX);
			return new clazz(x, y);
		}

	}
}