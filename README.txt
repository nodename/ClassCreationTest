This is a simple demonstration of class generation in Actionscript using the as3-commons-bytecode library.

Here I demonstrate creating parameterized classes (generics). In this example we create a Tuple class given a spec containing the names, types, and visibilities (public, protected, or private) of the class's data members.  The class is named appropriately, e.g. Tuple<String, Point, Rectangle>, and it is given a constructor method that requires parameters of the indicated types in the order that they will have in the tuple.  I use the as3-commons-bytecode library to generate the class, and then load the class into the current ApplicationDomain.  Once a couple of specified classes are loaded, I examine them with describeType() and construct an instance of each generated class.

The bytecode for the constructor doesn't depend in any way on the types of the parameters; it's just a matter of putting them on the stack and initializing the respective properties with them.

One thing that held me up for a while was determining the proper namespace for protected and local properties. It turns out to be the fully qualified classname with a single colon as the final separator; who knew.

I haven't provided accessors for the tuple properties, so for non-public members that would be an 'exercise for the reader'.

I'm loading the generated classes immediately, but there's code to write them out in swf format as well. So an AIR app like this could be included in a build process...

I was led to play with as3-commons-bytecode by the exciting work that Mike Labriola and James Ward presented at 360Flex in Denver. They demonstrate a bytecode-based framework for intercepting the load process of a Flex application and performing arbitrary changes before allowing Flex to start up.  The possibilities are vast:

http://www.jamesward.com/2011/04/26/introducing-mixing-loom-runtime-actionscript-bytecode-modification/
