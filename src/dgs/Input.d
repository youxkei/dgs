module dgs.Input;

import std.algorithm;
import std.exception;
public import derelict.sdl2.sdl;

uint[32] joyAliases;
uint[8] mouseAliases;
ubyte repeateDelay;
ubyte repeateInterval;
int threshold;

bool isKeyRepeated(size_t keycode)in{
    assert(keycode < SDL_NUM_SCANCODES);
}body{
	return keyStates[keycode].isRepeated;
}

bool isKeyPressed(size_t keycode)in{
    assert(keycode < SDL_NUM_SCANCODES);
}body{
	return keyStates[keycode].isPressedByKey || keyStates[keycode].isPressedByAllJoy || keyStates[keycode].isPressedByAllAxis || keyStates[keycode].isPressedByAllHat || keyStates[keycode].isPressedByMouse;
}

bool isKeyTriggered(size_t keycode)in{
    assert(keycode < SDL_NUM_SCANCODES);
}body{
    enforce(keycode < SDL_NUM_SCANCODES);
	return keyStates[keycode].triggerState == 1;
}

ubyte getKeyDir(){
	if(isKeyPressed(SDL_SCANCODE_UP) && isKeyPressed(SDL_SCANCODE_LEFT)){
		return 7;
	}else if(isKeyPressed(SDL_SCANCODE_UP) && isKeyPressed(SDL_SCANCODE_RIGHT)){
		return 9;
	}else if(isKeyPressed(SDL_SCANCODE_DOWN) && isKeyPressed(SDL_SCANCODE_LEFT)){
		return 1;
	}else if(isKeyPressed(SDL_SCANCODE_DOWN) && isKeyPressed(SDL_SCANCODE_RIGHT)){
		return 3;
	}else if(isKeyPressed(SDL_SCANCODE_DOWN)){
		return 2;
	}else if(isKeyPressed(SDL_SCANCODE_LEFT)){
		return 4;
	}else if(isKeyPressed(SDL_SCANCODE_RIGHT)){
		return 6;
	}else if(isKeyPressed(SDL_SCANCODE_UP)){
		return 8;
	}else{
		return 5;
	}
}

package:

void initInput(){
	repeateDelay = 10;
	repeateInterval = 4;
	threshold = 300;
	foreach(i; 0..min(SDL_NumJoysticks(), 4)){
		SDL_JoystickOpen(i);
	}
	SDLKeyStates = SDL_GetKeyboardState(null);
}

void updateKeyRepeat(){
	foreach(i; 1..SDL_NUM_SCANCODES){
		if(isKeyPressed(i)){
		    if(keyStates[i].triggerState == 0){
		        keyStates[i].triggerState = 1;
		    }else if(keyStates[i].triggerState == 1){
		        keyStates[i].triggerState = 2;
		    }

			if(keyStates[i].delayCount > 0) {
				keyStates[i].delayCount--;
				keyStates[i].isRepeated = false;
			}else if(keyStates[i].intervalCount > 0){
				keyStates[i].intervalCount--;
				keyStates[i].isRepeated = false;
			}else{
				keyStates[i].intervalCount = repeateInterval;
				keyStates[i].isRepeated = true;
			}
		}else{
		    keyStates[i].triggerState = 0;
			keyStates[i].isRepeated = false;
			keyStates[i].delayCount = 0;
			keyStates[i].intervalCount = 0;
		}
	}
}

void processInputEvent(const ref SDL_Event event){
	final switch(event.type){
		case SDL_KEYDOWN://キーボードのキーが押された
			pressByKey(event.key.keysym.scancode);
			break;
		case SDL_KEYUP://キーボードのキーが開放された
			releaseByKey(event.key.keysym.scancode);
			break;
		case SDL_JOYBUTTONDOWN://ゲームパッドのキーが押された
			pressByJoy(event.jbutton.which, joyAliases[event.jbutton.button]);
			break;
		case SDL_JOYBUTTONUP://ゲームパッドのキーが開放された。
			releaseByJoy(event.jbutton.which, joyAliases[event.jbutton.button]);
			break;
		case SDL_JOYAXISMOTION://ゲームパッドのアナログスティックが動いた。
            //X軸
			if(event.jaxis.axis == 0) {
				if(event.jaxis.value < -threshold){
					pressByAxis(event.jaxis.which, event.jaxis.axis, SDL_SCANCODE_LEFT);
				}else if(event.jaxis.value > threshold){
					pressByAxis(event.jaxis.which, event.jaxis.axis, SDL_SCANCODE_RIGHT);
				}else{
					releaseByAxis(event.jaxis.which, event.jaxis.axis, SDL_SCANCODE_LEFT);
					releaseByAxis(event.jaxis.which, event.jaxis.axis, SDL_SCANCODE_RIGHT);
				}
			//Y軸
			}else if(event.jaxis.axis == 1){
				if(event.jaxis.value > threshold){
					pressByAxis(event.jaxis.which, event.jaxis.axis, SDL_SCANCODE_DOWN);
				}else if(event.jaxis.value < -threshold){
					pressByAxis(event.jaxis.which, event.jaxis.axis, SDL_SCANCODE_UP);
				}else{
					releaseByAxis(event.jaxis.which, event.jaxis.axis, SDL_SCANCODE_DOWN);
					releaseByAxis(event.jaxis.which, event.jaxis.axis, SDL_SCANCODE_UP);
				}
			}
			break;
		case SDL_JOYHATMOTION://ハットスイッチが動いた
			if(event.jhat.value == SDL_HAT_CENTERED){
				releaseByHat(event.jhat.which, event.jhat.hat, SDL_SCANCODE_UP);
				releaseByHat(event.jhat.which, event.jhat.hat, SDL_SCANCODE_RIGHT);
				releaseByHat(event.jhat.which, event.jhat.hat, SDL_SCANCODE_DOWN);
				releaseByHat(event.jhat.which, event.jhat.hat, SDL_SCANCODE_LEFT);
			}else{
				if(event.jhat.value & SDL_HAT_UP){
					pressByHat(event.jhat.which, event.jhat.hat, SDL_SCANCODE_UP);
				}
				if(event.jhat.value & SDL_HAT_RIGHT){
					pressByHat(event.jhat.which, event.jhat.hat, SDL_SCANCODE_RIGHT);
				}
				if(event.jhat.value & SDL_HAT_DOWN){
					pressByHat(event.jhat.which, event.jhat.hat, SDL_SCANCODE_DOWN);
				}
				if(event.jhat.value & SDL_HAT_LEFT){
					pressByHat(event.jhat.which, event.jhat.hat, SDL_SCANCODE_LEFT);
				}
			}
			break;
		case SDL_MOUSEBUTTONDOWN:
			pressByMouse(mouseAliases[event.button.button]);
			break;
		case SDL_MOUSEBUTTONUP:
			releaseByMouse(mouseAliases[event.button.button]);
			break;
		case SDL_MOUSEMOTION:
			break;
	}
}

void clearKeyStates(){
    keyStates[] = KeyState.init;
}


private:

KeyState[SDL_NUM_SCANCODES] keyStates;
ubyte* SDLKeyStates;

void press(size_t code)in{
	assert(code < SDL_NUM_SCANCODES);
}body{
	if(!isKeyPressed(code)){
	    keyStates[code].triggerState = 1;
		keyStates[code].isRepeated = true;
		keyStates[code].delayCount = repeateDelay;
	}
}

void pressByKey(size_t code)in{
	assert(code < SDL_NUM_SCANCODES);
}body{
	press(code);
	keyStates[code].isPressedByKey = true;
}

void pressByJoy(size_t joy, size_t code)in{
	assert(joy <= 3);
	assert(code < SDL_NUM_SCANCODES);
}body{
	press(code);
	keyStates[code].isPressedByJoy[joy] = true;
}

void pressByAxis(size_t joy, size_t axis, size_t code)in{
	assert(joy <= 3);
	assert(axis <= 1);
	assert(code >= 0);
	assert(code < SDL_NUM_SCANCODES);
}body{
	press(code);
	keyStates[code].isPressedByAxis[joy][axis] = true;
}

void pressByHat(size_t joy, size_t hat, size_t code)in{
	assert(joy <= 3);
	assert(hat <= 1);
	assert(code < SDL_NUM_SCANCODES);
}body{
	press(code);
	keyStates[code].isPressedByHat[joy][hat] = true;
}

void pressByMouse(size_t code)in{
	assert(code < SDL_NUM_SCANCODES);
}body{
	press(code);
	keyStates[code].isPressedByMouse = true;
}

void releaseByKey(size_t code)in{
	assert(code < SDL_NUM_SCANCODES);
}body{
	keyStates[code].isPressedByKey = false;
}

void releaseByJoy(size_t joy, size_t code)in{
	assert(joy <= 3);
	assert(code < SDL_NUM_SCANCODES);
}body{
	keyStates[code].isPressedByJoy[joy] = false;
}

void releaseByAxis(size_t joy, size_t axis, size_t code)in{
	assert(joy <= 3);
	assert(axis <= 1);
	assert(code < SDL_NUM_SCANCODES);
}body{
	keyStates[code].isPressedByAxis[joy][axis] = false;
}

void releaseByHat(size_t joy, size_t hat, size_t code)in{
	assert(joy <= 3);
	assert(hat <= 1);
	assert(code < SDL_NUM_SCANCODES);
}body{
	keyStates[code].isPressedByHat[joy][hat] = false;
}

void releaseByMouse(size_t code)in{
	assert(code < SDL_NUM_SCANCODES);
}body{
	keyStates[code].isPressedByMouse = false;
}

struct KeyState{
	bool isPressedByKey;
	bool[4] isPressedByJoy;
	bool[2][4] isPressedByAxis;
	bool[2][4] isPressedByHat;
	bool isPressedByMouse;
	ubyte triggerState;
	bool isRepeated;
	ubyte delayCount;
	ubyte intervalCount;


@property:
    bool isPressedByAllJoy() {
        return
            isPressedByJoy[0] ||
            isPressedByJoy[1] ||
            isPressedByJoy[2] ||
            isPressedByJoy[3];
    }

    bool isPressedByAllAxis() {
        return
            isPressedByAxis[0][0] ||
            isPressedByAxis[0][1] ||
            isPressedByAxis[1][0] ||
            isPressedByAxis[1][1] ||
            isPressedByAxis[2][0] ||
            isPressedByAxis[2][1] ||
            isPressedByAxis[3][0] ||
            isPressedByAxis[3][1];
    }

    bool isPressedByAllHat() {
        return
            isPressedByHat[0][0] ||
            isPressedByHat[0][1] ||
            isPressedByHat[1][0] ||
            isPressedByHat[1][1] ||
            isPressedByHat[2][0] ||
            isPressedByHat[2][1] ||
            isPressedByHat[3][0] ||
            isPressedByHat[3][1];
    }
}
