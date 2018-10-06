package map;

class Cover extends h3d.scene.Object {
    public static inline var MIN_WIDTH:Float = 8 * Map.UNITS_PER_METER; //TODO properties
    public static inline var MIN_HEIGHT:Float = 1 * Map.UNITS_PER_METER; //TODO properties
    public static inline var MIN_DEPTH:Float = 0.8 * Map.UNITS_PER_METER; //TODO properties

    var slots:Array<Slot>;
    var coverMesh:h3d.scene.Mesh;

    public function new(size:h3d.Vector, color:Int, parent:CoverLine) {
        super(parent);

        var prim:h3d.prim.Cube = new h3d.prim.Cube(size.x, size.y, size.z, false);
        prim.unindex();
		prim.addNormals();
		prim.addUniformUVs(1.0);
		prim.addTangents();
        prim.translate( -size.x * 0.5, 0, 0); //bottom-front-centered

        coverMesh = new h3d.scene.Mesh(prim, this);
        coverMesh.material.color.setColor(color);

        slots = new Array<Slot>();
        slots.push(new Slot(0, size.y * 0.5 + 1.5 * Map.UNITS_PER_METER, 0, this));
        slots.push(new Slot(0, size.y * -0.5 - 1 * Map.UNITS_PER_METER, 0, this));
    }
}