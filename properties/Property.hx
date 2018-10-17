package properties;

class Property {
    public var value(default,null):Any;

    public function new(str:String) {
        value = parse(str);
    }

    function parse(str:String):Any {
        str = StringTools.trim(str);
        if(str.length <= 0) {
            trace("Parsing empty property - set to null");
            return null;
        }

        if(StringTools.startsWith(str, "[")
            && StringTools.endsWith(str, "]")) 
        {            
            str = str.substring(1, str.length - 1); //remove surrounding []
            return parseCoordinates(str);
        }
        else if(StringTools.startsWith(str, "list(")
            && StringTools.endsWith(str, ")"))
        {
            str = str.substring(5, str.length - 1); //remove surrounding list()
            return parseList(str);
        }
        else if(StringTools.startsWith(str, "\"")
            && StringTools.endsWith(str, "\""))
        {
            str = str.substring(1, str.length - 1); //remove surrounding quotes
            return str;
        }
        else 
        {
            return parseBasic(str);
        }
    }

    function parseCoordinates(str:String):Any {
        var values:Array<String> = str.split(","); //split values
        switch(values.length) {
            case 0: 
            {
                trace("Parsing invalid property (" + str + ")- set to null");
                return null;
            }
            case 1:
            {
                return parse(values[0]);
            }
            case 2:
            {
                return new h2d.col.Point(Std.parseFloat(values[0]), Std.parseFloat(values[1]));
            }
            case 3:
            {
                return new h3d.col.Point(Std.parseFloat(values[0])
                                        , Std.parseFloat(values[1])
                                        , Std.parseFloat(values[2]));
            }
            case 4:
            {
                return new h3d.Vector(Std.parseFloat(values[0])
                                    , Std.parseFloat(values[1])
                                    , Std.parseFloat(values[2])
                                    , Std.parseFloat(values[3]));
            }
            default: 
            {
                var container:Array<Float> = new Array<Float>();
                for(i in 0...values.length) {
                    container.push(Std.parseFloat(values[i]));
                }
                return container;
            }
        }
    }

    function parseList(str:String):Any {
        var values:Array<String> = str.split(","); //split values
        
        if(values.length <= 0) {
            trace("Invalid empty property list - set to null");
            return null;
        }

        var invalid:Bool = false;

        var arrayBool:Array<Null<Bool>> = values.map(parseBool);
        invalid = Lambda.exists(arrayBool, function(b:Null<Bool>):Bool {
            return b == null;
        });
        if(!invalid) {
            var res:Array<Bool> = arrayBool.map(function(v:Null<Bool>):Bool {
                return cast(v, Bool);
            });
            return res;
        }

        var arrayFloat:Array<Null<Float>> = values.map(parseFloat);
        invalid = Lambda.exists(arrayFloat, function(f:Null<Float>):Bool {
            return f == null || Math.isNaN(f);
        });
        if(!invalid) {
            var res:Array<Float> = arrayFloat.map(function(v:Null<Float>):Float {
                return cast(v, Float);
            });
            return res;
        }

        var arrayInt:Array<Null<Int>> = values.map(parseInt);
        invalid = Lambda.exists(arrayInt, function(i:Null<Int>):Bool {
            return i == null;
        });
        if(!invalid) {
            var res:Array<Int> = arrayInt.map(function(v:Null<Int>):Int {
                return cast(v, Int);
            });
            return res;
        }

        trace("Invalid property list (" + str + ") - could not resolve elements type, set to null");
        return null;
    }

    function parseBasic(str:String):Any {
        str = StringTools.trim(str);
        if(str.length <= 0) {
            trace("Parsing empty property - set to null");
            return null;
        }

        var boolVal:Null<Bool> = parseBool(str);
        if(boolVal != null) {
            return (boolVal : Bool);
        }

        var floatVal:Null<Float> = parseFloat(str);
        if(floatVal != null && !Math.isNaN(floatVal)) {
            return (floatVal : Float);
        }

        var intVal:Null<Int> = parseInt(str);
        if(intVal != null) {
            return (intVal : Int);
        }

        trace("Invalid property (" + str + ") - set to null");
        return null;
    }

    function parseBool(str:String):Null<Bool> {
        str = StringTools.trim(str);
        if(str.length <= 0) {
            trace("Parsing empty property - set to null");
            return null;
        }

        if(str == "true") {
            return true;
        } else if(str == "false") {
            return false;
        }
        return null;
    }

    function parseInt(str:String):Null<Int> {
        str = StringTools.trim(str);
        if(str.length <= 0) {
            trace("Parsing empty property - set to null");
            return null;
        }

        if(StringTools.startsWith(str, "#")) {
            return parseInt("0x" + str.substr(1));
        }
        return Std.parseInt(str);
    }

     function parseFloat(str:String):Null<Float> {
        str = StringTools.trim(str);
        if(str.length <= 0) {
            trace("Parsing empty property - set to null");
            return null;
        }

        if(str.indexOf(".") != -1) {
            return Std.parseFloat(str);
        }
        return null;
    }
}