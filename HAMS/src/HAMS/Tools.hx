package hams;
class Tools{
    static public function map(_x:Float,_lowI:Float,_highI:Float,_lowF:Float,_highF:Float):Float{
        var percent :Float = (_x-_lowI)/(_highI - _lowI);
        return (percent * (_highF-_lowF))+_lowF;
    }
}