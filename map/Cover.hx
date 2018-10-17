package map;

import properties.Properties;

class Cover extends h3d.scene.Object {
    var slots:Array<Slot>;
    var coverMesh:h3d.scene.Mesh;
    var minSize:h3d.col.Point;

    public function new(size:h3d.Vector, color:Int, parent:CoverLine) {
        super(parent);

        minSize = Properties.get("coverMinSize").clone();
        minSize.scale(Map.UNITS_PER_METER);

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

    public function getSlot(dir:hxd.Direction, ?global:Bool = true):h3d.Vector {
        var slot:Slot = (dir == hxd.Direction.Up ? slots[0] : slots[1]);
        return global ? slot.localToGlobal() : new h3d.Vector(x,y,z);
    }
}