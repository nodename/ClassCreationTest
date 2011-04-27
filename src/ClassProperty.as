package
{
	import avmplus.getQualifiedClassName;
	
	import org.as3commons.bytecode.emit.enum.MemberVisibility;
	
	public final class ClassProperty
	{
		private var _name:String;
		public function get accessorName():String { return _name; }
		public function get memberName():String
		{
			// prepend _ to name if visibility is private:
			return (_visibility == MemberVisibility.PRIVATE ? "_": "") + _name;
		}
		
		private var _type:Class;
		public function get type():Class { return _type; }
		
		private var _qualifiedClassName:String;
		public function get qualifiedClassName():String { return _qualifiedClassName; }
		public function get className():String { return _qualifiedClassName.split('::')[1]; }
		
		private var _visibility:MemberVisibility;
		public function get visibility():MemberVisibility { return _visibility; }
		
		public function ClassProperty(name:String, type:Class, visibility:MemberVisibility)
		{
			_name = name;
			_type = type;
			_qualifiedClassName = getQualifiedClassName(type);
			_visibility = visibility;
		}
	}
}