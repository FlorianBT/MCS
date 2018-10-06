package map;

class Generator {
    static var coverspace = 12 * Map.UNITS_PER_METER; //TODO properties
    static var coverOdds = [0.05, 0.7, 0.2, 0.5]; //TODO properties
    static var lastLine = [0,0,0,0];
    static var coverPos = [
        (Map.WIDTH * 0.95 - Cover.MIN_WIDTH) * 0.5,
        0,
        (Map.WIDTH * 0.95 - Cover.MIN_WIDTH) * -0.5
    ];
    
    static var totalLinesCount = 0;
    static var totalCoversCount = 0;

    var map:Map;
    var rand:hxd.Rand;

    public function new(target:Map) {
        map = target;
        rand = new hxd.Rand(0xF105EB); //TODO properties
    }

    public function reset() {
        for(floor in map.floors) {
            floor.remove();
        }
        for(cover in map.covers) {
            cover.remove();
        }

        map.floors = [];
        map.covers = [];
    }
    
    public function generate() {
        for(f in 0...4) {
            generateFloor();
        }
        
        generateCoverLines(10);
    }

    private function generateFloor() {
        var floor:Floor = makeFloor(map, Floor.DEFAULT_LENGTH, map.floors.length % 2 == 0 ? 0x68DB61 : 0x18AC11);
        if(map.floors.length > 0) {
            var prevFloor:Floor = map.floors[map.floors.length-1];
            floor.y = prevFloor.y + prevFloor.height;
        }
        map.floors.push(floor); 
    }

    public function generateCoverLines(lines:Int) {
        var coverY = map.covers.length > 0 ? map.covers[map.covers.length-1].y : coverspace * 0.75;
        var colors = [0x0000FF, 0xFFFFFF, 0xFF0000];        
        for(k in 0...lines) {
            var coverLine:CoverLine = new CoverLine(map);
            map.covers.push(coverLine);

            var vSpace:Float = coverspace;
            coverLine.y = (coverY + vSpace);
            coverY += vSpace;

            generateCovers(coverLine, colors[totalLinesCount % 3]); 
            totalLinesCount++;           
        }
    }

    public function generateCovers(coverLine:CoverLine, ?color:Int = 0xFF0000) {
        var roll:Float = -1;

        //get covers count
        var count:Int = -1;
        do {
            roll = rand.rand();
            count = getRollResult(roll);
            if(count == 0 || count == 3) {
                trace(count + "-" + lastLine[count]);
            }
        } while((count == 0 || count == 3) && lastLine[count] > 0);
        //never more than X cover lines with either 0 or 3 covers at a time

        for(k in 0...lastLine.length) {
            var v:Int = lastLine[k] + (k == count ? 5 : -1); //TODO properties
            lastLine[k] = hxd.Math.imax(0,v);
        }

        //pick covers positions
        var coverPlacement = [];
        while(coverPlacement.length < count) {
            var pick = rand.random(coverPos.length);
            if(coverPlacement.indexOf(pick) < 0) {
                coverPlacement.push(pick);
            }
        }

        for(i in 0...count) {
            var coverSize:h3d.Vector = new h3d.Vector(
                Cover.MIN_WIDTH * (1 + rand.srand(0.5)), 
                Cover.MIN_HEIGHT * (1 + rand.srand(0.35)), 
                Cover.MIN_DEPTH * (1 + rand.srand(0.2))
            );

            var cover:Cover = makeCover(coverLine, coverSize, color);
            totalCoversCount++;
            cover.x = coverPos[coverPlacement[i]]; //position
            
            //add noise
            var coverBounds:h3d.col.Bounds = cover.getBounds();
            cover.x += Map.WIDTH * rand.srand(0.03); //TODO properties
            cover.y += coverspace * rand.srand(0.02); //TODO properties

            coverLine.addCover(cover);
        }
    }

    private static function getRollResult(roll:Float):Int {
        var odd:Float = 0;
        for(i in 0...coverOdds.length) {
            odd += coverOdds[i];
            if(roll < odd) {
                return i;
            }
        }
        return coverOdds.length - 1;
    }

    private static function makeFloor(map:Map, ?height:Float = Floor.DEFAULT_LENGTH, ?color:Int = 0xF0F0F0):Floor {
        return new Floor(Map.WIDTH, height, color, map);
    }

    private static function makeCover(line:CoverLine, ?size:h3d.Vector = null, ?color:Int = 0xFF0000):Cover {
        if(size == null) {
            size = new h3d.Vector(Cover.MIN_WIDTH, Cover.MIN_HEIGHT, Cover.MIN_DEPTH);
        }
        return new Cover(size, color, line);
    }
}