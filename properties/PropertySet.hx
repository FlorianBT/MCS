package properties;

import haxe.ds.Map;

class PropertySet {
    var data:Map<String,Property>;

    public var count(get,never):Int;
    public function get_count():Int { return data != null ? Lambda.count(data) : 0; }

    public function new() {
        clear();
    }

    public function clear():Void {
        data = new Map<String,Property>();
    }

    public function add(key:String, value:String):Void {
        if(data.exists(key)) {
            trace("Property <" + key + "> already exists.");
            return;
        }
        data.set(key, new Property(value));
        trace("Added property <" + key +  " => " + value + ">");
    }

    public function get<T>(key:String):T {
        if(!data.exists(key)) {
            trace("Cannot find property <" + key + ">");
            return null;
        }

        return cast data[key];
    }
}