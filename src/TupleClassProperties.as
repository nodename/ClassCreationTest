package
{
	import avmplus.getQualifiedClassName;

	public class TupleClassProperties
	{
		private var _properties:Vector.<ClassProperty>;
		public function get properties():Vector.<ClassProperty> { return _properties; }
		
		private var _tupleClassName:String;
		public function get tupleClassName():String { return _tupleClassName; }

		public function TupleClassProperties(properties:Array)
		{
			_properties = Vector.<ClassProperty>(properties);
			
			var types:Array = [];
			const numProps:uint = _properties.length;
			for (var i:uint = 0; i < numProps; i++)
			{
				types.push(_properties[i].type);
			}
			_tupleClassName = getTupleClassName.apply(null, types);
		}
		
		public static function getTupleClassName(... types):String
		{
			const numProps:uint = types.length;
			var tupleClassName:String = "Tuple<" + getQualifiedClassName(types[0]).split('::')[1];
			for (var i:uint = 1; i < numProps; i++)
			{
				tupleClassName += ", " + getQualifiedClassName(types[i]).split('::')[1];
			}
			tupleClassName += ">";
			return tupleClassName;
		}
	}
}