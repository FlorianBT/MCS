package map;

class Floor extends h3d.scene.Mesh {
    public static inline var DEFAULT_LENGTH:Float = 50 * Map.UNITS_PER_METER;

    var floor:h3d.scene.Mesh;

    public var width(get, never) : Float;
    inline function get_width() return getBounds().xSize;

    public var height(get, never) : Float;
    inline function get_height() return getBounds().ySize;

    public function new(width:Float, height:Float, color:Int, parent:Map) {
        var pts = new Array();
        pts.push(new h3d.col.Point(-width * 0.5, 0, 0));
        pts.push(new h3d.col.Point(width * 0.5, 0, 0));
        pts.push(new h3d.col.Point(-width * 0.5, height, 0));
        pts.push(new h3d.col.Point(width * 0.5, height, 0));
        //bottom centered

        var n:h3d.col.Point = new h3d.col.Point(0,0,1);
        var normals = new Array();
        for(i in 0...pts.length) {
            normals.push(n);
        }

        var uvs = [];
		var a = new h3d.prim.UV(0, 1);
		var b = new h3d.prim.UV(1, 1);
		var c = new h3d.prim.UV(0, 0);
		var d = new h3d.prim.UV(1, 0);
		for( i in 0...pts.length >> 2 ) {
			uvs.push(a);
			uvs.push(b);
			uvs.push(c);
			uvs.push(d);
		}

        var prim = new h3d.prim.Quads(pts, uvs, normals);

        super(prim, parent);

        material.color.setColor(color);
    }
}