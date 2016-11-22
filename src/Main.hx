import luxe.States;
import luxe.Input.KeyEvent;
import luxe.Input.Key;

import game.PostProcess;
import game.states.*;

import pgr.dconsole.DC;

class Main extends luxe.Game {
    static public var states :States;
    var fullscreen :Bool = false;
    var postprocess :PostProcess;

    static public var bloom :Float = 0.0;
    static public var shift :Float = 0.0;

    override function config(config :luxe.GameConfig) {
        config.render.antialiasing = 4;

        // config.preload.textures.push({ id: 'assets/images/brick-wall.png' });
        config.preload.textures.push({ id: 'assets/images/circuitry.png' });
        config.preload.textures.push({ id: 'assets/images/computing.png' });
        config.preload.textures.push({ id: 'assets/images/database.png' });
        config.preload.textures.push({ id: 'assets/images/finger-print.png' });
        config.preload.textures.push({ id: 'assets/images/fire-ring.png' });
        config.preload.textures.push({ id: 'assets/images/hazard-sign.png' });
        config.preload.textures.push({ id: 'assets/images/honeypot.png' });
        config.preload.textures.push({ id: 'assets/images/id-card.png' });
        config.preload.textures.push({ id: 'assets/images/leeching-worm.png' });
        config.preload.textures.push({ id: 'assets/images/plug.png' });
        config.preload.textures.push({ id: 'assets/images/processor.png' });
        config.preload.textures.push({ id: 'assets/images/radar-sweep.png' });
        config.preload.textures.push({ id: 'assets/images/shieldcomb.png' });
        config.preload.textures.push({ id: 'assets/images/spider-bot.png' });
        config.preload.textures.push({ id: 'assets/images/stopwatch.png' });
        config.preload.textures.push({ id: 'assets/images/trojan-horse.png' });
        config.preload.textures.push({ id: 'assets/images/checker.png' });

        config.preload.textures.push({ id: 'assets/images/overlay_filter.png' });

        config.preload.shaders.push({ id: 'postprocess', frag_id: 'assets/shaders/fullretard.frag', vert_id: 'default' });
        #if with_shader
        config.preload.shaders.push({ id: 'circuits', frag_id: 'assets/shaders/circuits.glsl', vert_id: 'default' });
        #end

        return config;
    }

    override function ready() {
        // Optional, set a consistent scale camera mode for the entire game
		// this is a luxe's wip feature
		Luxe.camera.size = new luxe.Vector(960, 640);
		// Luxe.camera.size_mode = luxe.Camera.SizeMode.cover;
		Luxe.camera.center = new luxe.Vector();

        luxe.tween.Actuate.defaultEase = luxe.tween.easing.Quad.easeInOut;

        Luxe.renderer.batcher.on(prerender, function(_) { Luxe.renderer.state.lineWidth(4); });
        Luxe.renderer.batcher.on(postrender, function(_) { Luxe.renderer.state.lineWidth(1); });

        Luxe.renderer.clear_color.set(25/255, 35/255, 55/255);

        var shader = Luxe.resources.shader('postprocess');
        shader.set_vector2('resolution', Luxe.screen.size);
        shader.set_float('bloom', 0.4);
        shader.set_float('shift', 0.0);
        postprocess = new PostProcess(shader);
        // postprocess.toggle(); // disable shader for now

        states = new States({ name: 'state_machine' });
        var worldstate = new WorldState();
        states.add(worldstate);
        states.set(WorldState.StateId);

        var theme :pgr.dconsole.DCThemes.Theme = {
    		CON_C 		: 0x353535,
    		CON_TXT_C 	: 0x00FF00,
    		CON_A		: .7,
    		CON_TXT_A	: 1,

    		PRM_C		: 0x454545,
    		PRM_TXT_C	: 0xFFFF00,

    		MON_C		: 0x000000,
    		MON_TXT_C	: 0xFF00FF,
    		MON_A		: .7,
    		MON_TXT_A	: .7,

    		LOG_WAR	: 0xFFFF00, // Warning messages color;
    		LOG_ERR	: 0xFF0000, // Error message color;
    		LOG_INF	: 0x00FFFF, // Info messages color;
    		LOG_CON	: 0x00FF00, // Confirmation messages color;
    	}

        DC.init(30, 'DOWN', theme);
        // DC.log("This text will be logged.");
        DC.registerFunction(function() { postprocess.toggle(); }, "toggle_shader");
        DC.registerObject(Main, "Main");
        DC.registerObject(worldstate, "world");
        // DC.registerClass(Math, "Math");
    }

    // Scale camera's viewport accordingly when game is scaled, common and suitable for most games
	// override function onwindowsized(e: luxe.Screen.WindowEvent) {
    //     Luxe.camera.viewport = new luxe.Rectangle(0, 0, e.event.x, e.event.y);
    // }

    override function onprerender() {
        if (postprocess != null) postprocess.prerender();
    }

    override function update(dt :Float) {
        if (postprocess != null) {
            postprocess.shader.set_float('time', Luxe.core.tick_start + dt);
            postprocess.shader.set_float('bloom', bloom);
            postprocess.shader.set_float('shift', shift);
        }
    }

    override function onpostrender() {
        if (postprocess != null) postprocess.postrender();
    }

    override function onkeyup(e :KeyEvent) {
        if (e.keycode == Key.enter && e.mod.alt) {
            fullscreen = !fullscreen;
            Luxe.snow.runtime.window_fullscreen(fullscreen, true /* true-fullscreen */);
        } /* else if (e.keycode == Key.key_s) {
            // save state
            Luxe.io.string_save('save', 'blah test');
        } else if (e.keycode == Key.key_l) {
            // load saved state
            trace('loaded state: ' + Luxe.io.string_load('save'));
        } else if (e.keycode == Key.key_p) {
            postprocess.toggle();
        } else if (e.keycode == Key.key_m) {
            states.set(WorldState.StateId);
        }
        */
    }
}
