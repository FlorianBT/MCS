package properties;

class Properties {
    static var loaded:Bool = false;
    static var properties:PropertySet;

    public static function load(?embeded:Bool = true):Void {
        if(loaded) {return;}

        properties = new PropertySet();

        var content = embeded ? loadEmbeded() : loadFS();
        if(content != null) {
            parse(content, true);
            trace("Loaded " + properties.count + " properties");
        }

        loaded = true;
    }

    private static function loadEmbeded():String {
        var res:hxd.res.Resource = hxd.Res.game;
        trace("Loading properties : " + res.name);
        return res.entry.getText();
    }

    private static function loadFS():String {
        try {
            var fs:hxd.fs.LocalFileSystem = new hxd.fs.LocalFileSystem($v{"res"});
            var file:hxd.fs.FileEntry = fs.get("game.properties");
            var content:String = file.getText();
            return content;
        } catch (e:hxd.fs.NotFound) {
            trace("Properties file not found @" + e.path);
            return "";
        }
    }

    private static function parse(content:String, ?clear:Bool = false):Void {
        if(clear) { properties.clear(); }

        if(content.length <= 0) { return; }

        var lines:Array<String> = content.split("\n");
        for(line in lines) {
            var l:String = StringTools.trim(line);          
            if(l.length <= 0) { continue; }
            if(StringTools.startsWith(l,"#")) { continue; }  
            var lineData:Array<String> = l.split(":");
            if(lineData.length != 2) {
                trace("Invalid property line :\n>> " + l);
                continue;
            }
            properties.add(lineData[0], lineData[1]);
        }
    }

    public static function get<T>(key:String):T {
        return properties.get(key);
    }
}