
/*
class CameraHandler extends h3d.scene.Object {    
    var cam:h3d.Camera;

    var speed:Float;

    public function new(scene:h3d.scene, ?sp = 10.) {
        super(scene);
        cam = scene.camera;
        speed = sp; 
    }

    public function move(dir:hxd.Direction, dt:Float) {   
        var f = speed * dt;
        var dx = dir.x * f;
        var dy = dir.y * f;
        cam.pos.x += dx; cam.pos.y += dy;
        cam.target.x += dx; cam.target.y += dy;
    }

    override function onEvent( e : hxd.Event ) {
		var p : h3d.scene.Object = this;
		while( p != null ) {
			if( !p.visible ) {
				e.propagate = true;
				return;
			}
			p = p.parent;
		}

		switch( e.kind ) {
		case EWheel:
			zoom(e.wheelDelta);
		default:
		}
	}
}
*/

class CameraHandler extends h3d.scene.CameraController {
    public function new(?distance,?parent) {
		super(distance, parent);
		name = "CameraHandler";
        panSpeed = 6.;
	}

    override function onEvent( e : hxd.Event ) {
		var p : h3d.scene.Object = this;
		while( p != null ) {
			if( !p.visible ) {
				e.propagate = true;
				return;
			}
			p = p.parent;
		}

		switch( e.kind ) {
		case EWheel:
			zoom(e.wheelDelta);
		default:
		}
	}

    public function move(dir:hxd.Direction, dt:Float) {
        var m = panSpeed * dt;
        trace(dir);
        var v:h3d.Vector = new h3d.Vector(-dir.x * m, dir.y * m, 0, 0);
        targetOffset = targetOffset.add(v);
    }
}