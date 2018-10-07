package map;

class CoverLine extends h3d.scene.Object {
    var covers:Array<Cover>;

    public var count(get, never) : Float;
    inline function get_count() return covers.length;

    public function new(parent:Map) {
        super(parent);
        covers = new Array<Cover>();
    }

    public function addCover(cover:Cover) {
        covers.push(cover);
    }

    public inline function getCover(index:Int) {
        return covers[index];
    }
}