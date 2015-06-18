package hams;
import flambe.animation.AnimatedFloat;
class Tools{
    static public function map(_x:Float,_lowI:Float,_highI:Float,_lowF:Float,_highF:Float):Float{
        var percent :Float = (_x-_lowI)/(_highI - _lowI);
        return (percent * (_highF-_lowF))+_lowF;
    }

    // Moves float slightly closer to target value based on a specific amount of change
    static public function Lerp(from:AnimatedFloat, to:Float, _amt:Float):Float { // FOR ANIMATED FLOAT
        var increase = false;
        if (from._ < to) {
            increase = true;
        }
        else 
            increase = false;
        
        var value_to_go_to = from._ + _amt;
        if (increase) {
            if (value_to_go_to > to) {
                value_to_go_to = to;
            }
        }
        else {
            if (value_to_go_to < to) {
                value_to_go_to = to;
            }
        }
        return value_to_go_to;
    }
    
    // Moves float slightly closer to target value based on a specific amount of change
    static public function LerpFloat(from:Float, to:Float, _amt:Float):Float { // FOR GENERAL FLOAT
        var increase = false;
        if (from < to) {
            increase = true;
        }
        else 
            increase = false;
        
        var value_to_go_to = from + _amt;
        if (increase) {
            if (value_to_go_to > to) {
                value_to_go_to = to;
            }
        }
        else {
            if (value_to_go_to < to) {
                value_to_go_to = to;
            }
        }
        return value_to_go_to;
    }
}