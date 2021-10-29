/**
 * This file have been transpiled from Actionscript 3.0 to 2.0, any changes made to this file will be overwritten once it is transpiled again
 */

import stateTypes.*
import core.JSON

import stateTypes.MovieClipTranspilerState;
import core.TranspiledMovieClip;

/**
 * ...
 * @author notSafeForDev
 */
class stateTypes.MovieClipTranspilerStateReference extends StateReference {
	
	private var state : MovieClipTranspilerState;
	
	public function MovieClipTranspilerStateReference(_state : MovieClipTranspilerState) {
		super();
		state = _state;
	}
	
	public function get value() : TranspiledMovieClip {
		return state.getValue();
	}
}