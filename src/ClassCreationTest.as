package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.ApplicationDomain;
	import flash.utils.describeType;
	
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	
	public class ClassCreationTest extends Sprite
	{
		public function ClassCreationTest()
		{
			const pointTupleClassProperties:TupleClassProperties = new TupleClassProperties(
				[
					new ClassProperty("first", Point, MemberVisibility.PUBLIC)
					, new ClassProperty("second", Point, MemberVisibility.PUBLIC)
					, new ClassProperty("third", Point, MemberVisibility.PUBLIC)
					, new ClassProperty("fourth", Point, MemberVisibility.PUBLIC)
				]);
			const rectTupleClassProperties:TupleClassProperties = new TupleClassProperties(
				[
					new ClassProperty("first", Rectangle, MemberVisibility.PUBLIC)
					, new ClassProperty("second", Rectangle, MemberVisibility.PUBLIC)
					, new ClassProperty("third", Rectangle, MemberVisibility.PUBLIC)
					, new ClassProperty("fourth", Rectangle, MemberVisibility.PUBLIC)
				]);
			TupleClassGenerator.getTupleClass(pointTupleClassProperties, onClassReady);
			TupleClassGenerator.getTupleClass(rectTupleClassProperties, onClassReady);
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
			const p2:Point = new Point(4, 3);
			const p3:Point = new Point(-4, -3);
			const pointTuple:Object = makeTuple(p0, p1, p2, p3);
			trace(describeType(pointTuple));
			trace(pointTuple);
			trace(pointTuple.fourth);
			
			trace();
			
			const rect0:Rectangle = new Rectangle(0, 0, 100, 100);
			const rect1:Rectangle = new Rectangle(50, 50, 150, 150);
			const rectTuple:Object = makeTuple(rect0, rect1, rect0, rect1);
			trace(describeType(rectTuple));
			trace(rectTuple);
			trace(rectTuple.fourth);
			//trace(rectTuple.second);
		}
		
		private function makeTuple(x:*, y:*, z:*, w:*):Object
		{
			const types:Array = [ (x as Object).constructor, (y as Object).constructor, (z as Object).constructor, (w as Object).constructor ];
			const tupleClassName:String = TupleClassProperties.getTupleClassName.apply(null, types);
			const clazz:Class = ApplicationDomain.currentDomain.getDefinition(TupleClassGenerator.GENERATED_CLASS_PACKAGE + "::" + tupleClassName) as Class;
			//const clazz:Class = TupleClassGenerator.tupleClass(typeX);
			return new clazz(x, y, z, w);
		}

	}
}