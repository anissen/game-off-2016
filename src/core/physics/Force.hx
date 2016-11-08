package core.physics;

interface Force {
	function turnOn() :Void;
	function turnOff() :Void;
	function isOn() :Bool;
	function isOff() :Bool;
	function apply() :Void;
}
