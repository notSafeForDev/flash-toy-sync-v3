/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON

import core.TranspiledMovieClip;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.MovieClipTranspilerState extends State {
	
	public function MovieClipTranspilerState(_defaultValue : TranspiledMovieClip) {
		super(_defaultValue, MovieClipTranspilerStateReference);
	}
	
	public function getValue() : TranspiledMovieClip {
		return value;
	}
	
	public function setValue(_value : TranspiledMovieClip) : Void {
		value = _value;
	}
}