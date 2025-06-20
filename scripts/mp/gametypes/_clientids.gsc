#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\mp\gametypes\_globallogic_ui;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_loadout;
#using scripts\shared\hud_util_shared;
#using scripts\shared\bots\_bot;
#using scripts\shared\weapons_shared;
#using scripts\shared\array_shared;
#using scripts\shared\math_shared;
#using scripts\mp\gametypes\_globallogic_score;
#insert scripts\shared\shared.gsh;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\hud_shared;
#using scripts\mp\_pickup_items;

#using scripts\shared\bb_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\persistence_shared;
#using scripts\shared\rank_shared;
#using scripts\shared\util_shared;
#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_util;

#using scripts\shared\bots\_bot;

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_wager;

#using scripts\mp\_challenges;
#using scripts\mp\_scoreevents;
#using scripts\mp\_util;
#using scripts\mp\killstreaks\_killstreak_weapons;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_counteruav;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\_teamops;

#insert scripts\shared\abilities\_ability_util.gsh;


#precache( "material", "damage_feedback" );

/*

violet - wip
radiant base edit by @30018


        ** - important
        
        ++
        current ideas:

        unlimited boosts
        working change class
        add more of my binds when im not lazy
        infinite nac would b cool but im taking a break from looking in2 that
        ** please organize this code. everything is everywhere
        ** figuring out the giveweapon / switchtoweapon problem. maybe its just me using the wrong weapon names. idk
        color settings / save on spawn
        ** match bonus
        look into ladder functions





        ++
        feature list (so far):
        

        the cool gameside stuff:
        reasonable ts fov / fps dvars can be set through menu (fps: 60, 75, 90, 144, 333 - fov: 89, 90, 91, 92, 93, 94)
        timer settings - unlimited, add minute, remove minute
        reset rounds
        enabled sui - god mode on round end   
        mw2 round end - able to move for 1 second after the round has ended
        change class mid game
        toggleable hud
        load position on spawn (if defined) - this goes for both bots and players
        bot settings r done i believe ill prob add some more stuff if i think of something
        single - quad bolt movement points w/ flexible timing
        bots automatically freeze on spawn (if u wna play legit setup or sum unfreeze bots in menu)
        round restart / game end (add cancel func)
        gravity


        save n load:
        can turn this off in main:
        save: crouch + up + frag 
        load: crouch + down

        binds - nac, instaswap, empty clip, one bullet, *set canswap:
        ^ *** change first 3 classes bind (&changeclassthreecanbind) is being used as a canswap selector for now LOL
        ^ *** will make seperate when i figure out how to make class change work. soon soon..
        eb / eb delay / eb range - self explanatory -.- 
        auto prone
        prone spins
        timescale / toggle timescale in killcam 

*/



// welcome

#namespace clientids;

REGISTER_SYSTEM( "clientids", &__init__, undefined )
  
function __init__()
{
    callback::on_start_gametype( &init );
}

function init()
{
    
    level.grav=true;
    level.clientid = 0;
    level.result = 1;
    level.firstHostSpawned = false;
    level.callDamage = level.callbackPlayerDamage;
    level.player_out_of_playable_area_monitor = 0; 

    setDvar("bg_prone_yawcap", "360");

    level thread removeSkyBarrier();
    level thread onPlayerConnect();
}

function onPlayerConnect()
{
    for(;;)
    {
        level waittill("connecting", player);
        player.MenuInit = false;


        if(player isHost())
        player.status = "Host";
        else 
        player.status = "Verified";


        player giveMenu();
        player thread onPlayerSpawned();
        player thread monitor_class();
        game["strings"]["change_class"] = undefined; 

        player waittill( "spawned_player" );
        //player thread matchbonusthread();
        player thread dosaveandload();
        player setplayerangles( player.pers[ "vars"][ "a"] );
        player setorigin( player.pers[ "vars"][ "o"] );



    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            
            bot setplayerangles( bot.pers[ "vars"][ "ba"] );
            bot setorigin( bot.pers[ "vars"][ "bo"] );
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
            wait 0.5;
            bot freezecontrols(true);
        }
    }

    }
}


function percs()
{
        self setperk("specialty_unlimitedsprint");
        self setperk("specialty_sprintfirerecovery");
        self setperk("specialty_sprintrecovery");
        self setperk("specialty_sprintgrenadetactical");
        self setperk("specialty_sprintgrenadelethal");
        self setperk("specialty_sprintfire");
        self setperk("specialty_sprintequipment");
        self setperk("specialty_fastladderclimb");
        self setperk("specialty_fallheight");
        self setperk("specialty_extraammo");
        self setperk("specialty_movefaster");
        self setperk("specialty_grenadepulldeath");
        self setperk("specialty_holdbreath");
        self setperk("specialty_sprintequipment");
        self setperk("specialty_fastmeleerecovery");        
        self setperk("specialty_earnmoremomentum");
        self setperk("specialty_combat_efficiency");
        self setperk("specialty_nottargetedbyrobot");
        self setperk("specialty_nottargetedbysentry");
        self setperk("specialty_jetcharger");
        self setperk("specialty_jetpack");    
        self setperk("specialty_fasttoss");
        self setperk("specialty_jetnoradar");  
        self setperk("specialty_fastweaponswitch");
        self setperk("specialty_fastequipmentuse");   
        self setperk("specialty_fastmantle");   
        self setperk("specialty_fastads");
}

function onPlayerSpawned() 
{
    self endon("disconnect");
    level endon("game_ended");
    isFirstSpawn = false;
   // init_afterhit();
    for(;;)
    {
        
        self waittill("spawned_player");

        if(!level.firstHostSpawned && self.status == "Host")
        {
            thread initOverFlowFix();

            level.firstHostSpawned = true;
        }

		self.kctime = true;
    	self.hudon = true;    
        self.boltspeed = 1.5;  
        self.frozenbots = true;
        self.monitor = undefined;
        self.stupidweapon = "briefcase_bomb";  
        self.malagun = 1;
        self.godmode = true;
        self enableinvulnerability();
        self.afterwait = undefined;      

        setDvar("timescale", 1);
        

        self.pers["loc"] = true;
        self.pers["saveposbolt"] = self.origin;
        self thread trackDoubleJumpDistanceL();
        self thread player_monitor_doublejumps();
        
        self thread changebotver();
     //   self thread callsaved();
        self thread mw2();
      //  self thread twochances();
        
    	self setclientuivisibilityflag("g_compassShowEnemies", 1);
        self freezecontrols(false);

        if(!isFirstSpawn)
        {
            isFirstSpawn = true;
            self thread percs();
            wait 6;
            self iprintlnbold("violet (^5private^7) by ^6injuste");
            wait 2;
            self iprintlnbold("[{+speed_throw}] ^6+^7 [{+actionslot 3}] to ^2open^7 menu");
        
        }
    
    }
}




function initOverFlowFix()
{
        // tables
        self.stringTable = [];
        self.stringTableEntryCount = 0;
        self.textTable = [];
        self.textTableEntryCount = 0;
       
        if(isDefined(level.anchorText) == false)
        {
                level.anchorText = hud::createServerFontString("default",1);
                level.anchorText setText("anchor");
                level.anchorText.alpha = 0;
               
                level.stringCount = 0;
                level thread monitorOverflow();
        }
}




function monitorOverflow()
{
        level endon("disconnect");
 
   
        level.test = hud::createServerFontString("default", 1);
        level.test setText("xTUL");
        level.test.alpha = 0;
        for(;;)
        {
                if(level.stringCount >= 60)
                {
                        level.stringCount = 0;
                        foreach(player in level.players)
                        {
                    if(player.menu.open && player isVerified())
                            player recreateText();
                        }
                }
               
                wait 0.05;
        }
}








function fovchange()

{
    if(!self.fovchange)
    {
    self iprintlnbold("fov: ^689");
    setDvar("cg_fov_default", "89");
        self.fovchange = 89;
    } else { 

    if(self.fovchange == 89)
    {
    self iprintlnbold("fov: ^690");
    setDvar("cg_fov_default", "90");
        self.fovchange = 90;
    } else {
        if( self.fovchange == 90 )
        {
            self.fovchange = 91;
    setDvar("cg_fov_default", "91");
    self iprintlnbold("fov: ^691");

    } else {
        if( self.fovchange == 91 )
        {
            self.fovchange = 92;
    setDvar("cg_fov_default", "92");
    self iprintlnbold("fov: ^692");

    } else {
        if( self.fovchange == 92 )
        {
        self.fovchange = 93;
    setDvar("cg_fov_default", "93");
    self iprintlnbold("fov: ^693");
    } else {
        if( self.fovchange == 93 )
        {
            self.fovchange = 94;
    setDvar("cg_fov_default", "94");
    self iprintlnbold("fov: ^694");
    } else {
        if( self.fovchange == 94 )
        {
            self.fovchange = 89;
    setDvar("cg_fov_default", "89");
    self iprintlnbold("fov: ^689");
    }
    }
    }
    }
    }
    
    }
    }
}


function fpschange()
{
    if(!self.fpschange)
    {
        self iprintlnbold("max fps: ^660");
	    setDvar("com_maxfps", "60");
        self.fpschange = 60;
    } else {

    if(self.fpschange == 60)
    {
        self iprintlnbold("max fps: ^675");
	    setDvar("com_maxfps", "75");
        self.fpschange = 75;
    } else {
        if( self.fpschange == 75 )
        {
            self.fpschange = 90;
	        setDvar("com_maxfps", "90");
            self iprintlnbold("max fps: ^690");

    } else {
        if( self.fpschange == 90 )
        {
            self.fpschange = 144;
	    setDvar("com_maxfps", "144");
        self iprintlnbold("max fps: ^6144");

    } else {
        if( self.fpschange == 144 )
        {
        self.fpschange = 333;
	    setDvar("com_maxfps", "333");
        self iprintlnbold("max fps: ^6333");
    } else {


        if( self.fpschange == 333 )
        {

        self.fpschange = 60;
	    setDvar("com_maxfps", "60");
        self iprintlnbold("max fps: ^660");
    }
    }
    }
    }
    
    }

    }
    }


function autoprone()
{
	if(!self.autoprone)
	{
		self.autoprone = true;
		self thread autoprone1();
		self iprintln("auto prone: ^6on");
	}
	else
	{
        self notify("AutoProneOFF");
		self.autoprone = undefined;
		self iprintln("auto prone: ^5off");
	}
}

function autoprone1() 
{
    level waittill( "game_ended" );
    self endon("AutoProneOFF");
        wait 0.01;
        self setstance( "prone" );
        wait 0.5;
        self setstance( "prone" );
        wait 0.5;
        self setstance( "prone" );
        wait 0.5;
        self setstance( "prone" );
        wait 0.5;
        self setstance( "prone" );
        wait 0.5;
        self setstance( "prone" );
    }


/*
function init_afterhit()
{

        self.afterhit[0] = SpawnStruct();
        self.afterhit[0].weap = "smg_standard";
        self.afterhit[0].on = false;

        self.afterhit[1] = SpawnStruct();
        self.afterhit[1].weap = "smg_versatile";
        self.afterhit[1].on = false;

        self.afterhit[2] = SpawnStruct();
        self.afterhit[2].weap = "shotgun_precision";
        self.afterhit[2].on = false;

        self.afterhit[3] = SpawnStruct();
        self.afterhit[3].weap = "knife_loadout";
        self.afterhit[3].on = false;

        self.afterhit[4] = SpawnStruct();
        self.afterhit[4].weap = "pistol_fullauto";
        self.afterhit[4].on = false;

        self.afterhit[5] = SpawnStruct();
        self.afterhit[5].weap = "ar_marksman";
        self.afterhit[5].on = false;

        self.afterhit[6] = SpawnStruct();
        self.afterhit[6].weap = "ar_fastburst";
        self.afterhit[6].on = false;
    
        self.afterhit[7] = SpawnStruct();
        self.afterhit[7].weap = "smg_burst";
        self.afterhit[7].on = false;

        self.afterhit[8] = SpawnStruct();
        self.afterhit[8].weap = "smg_longrange";
        self.afterhit[8].on = false;

}
*/
function dropWeapon()
{
    self dropItem(self getCurrentWeapon());
}



/*
function changeClass()
{
        self endon("disconnect");
        self endon("death");
 
        self globallogic_ui::beginClassChoice();
        for(;;)
        {
                if(self.pers["changed_class"])
                        self loadout::giveLoadout( self.team, self.curclass );
                wait 0.05;
        }
}

*/



function GravityMod550()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity","550");
        level.grav=false;
        self iprintln("gravity set to: ^6550");
    }
    else
    {
        setDvar("bg_gravity","800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}

function GravityMod500()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity","500");
        level.grav=false;
        self iprintln("gravity set to: ^6500");
    }
    else
    {
        setDvar("bg_gravity","800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}


function GravityMod450()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "450");
        level.grav=false;
        self iprintln("gravity set to: ^6450");
    }
    else
    {
        setDvar("bg_gravity", "800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}

function GravityMod400()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "400");
        level.grav=false;
        self iprintln("gravity set to: ^6400");
    }
    else
    {
        setDvar("bg_gravity", "800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}

function GravityMod350()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "350");
        level.grav=false;
        self iprintln("gravity set to: ^6350");
    }
    else
    {
        setDvar("bg_gravity", "800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}

function GravityMod300()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "300");
        level.grav=false;
        self iprintln("gravity set to: ^6300");
    }
    else
    {
        setDvar("bg_gravity", "800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}



function GravityMod250()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "250");
        level.grav=false;
        self iprintln("gravity set to: ^6250");
    }
    else
    {
        setDvar("bg_gravity", "800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}

function GravityMod200()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "200");
        level.grav=false;
        self iprintln("gravity set to: ^6200");
    }
    else
    {
        setDvar("bg_gravity", "800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}

function GravityMod150()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "150");
        level.grav=false;
        self iprintln("gravity set to: ^6150");
    }
    else
    {
        setDvar("bg_gravity", "800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}

function rmalas1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.mala))
    {
        self iPrintLn("^6mala with shots^6 on^7, press [{+Actionslot 1}] to use");
        self.mala = true;
        
        while(isDefined(self.mala))
        {
            if(self ActionSlotOneButtonPressed() && !self.menu.open)
            {
                self thread malalol();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.mala)) 
    { 
    self iPrintLn("^6mala with shots bind ^5deactivated");
    self.mala = undefined; 

    } 
}
/*

function altswap()
{
    if( self.pers[ "aims"][ "altswap"] == 0 )
    {
        self iprintlnbold( "altswap ^2on" );
        self giveweapon( "pistol_standard");
        self.pers["aims"]["altswap"] = 1;
        self altswapgiveback();
        self seteverhadweaponall( 1 );
    }
    else
    {
        if( self hasweapon( "pistol_standard" ) )
        {
            self notify( "endaltswap" );
            self takeweapon( "pistol_standard" );
            self iprintlnbold( "altswaps ^1off" );
            self.pers["aims"]["altswap"] = 0;
        }
    }

}

function altswapgiveback()
{
    self endon( "endaltswap" );
    for(;;)
    {
    self waittill( "changed_class" );
    wait 0.2;
    self giveweapon( "pistol_standard", 0, 1 );
    self.pers["aims"]["altswap"] = 1;
    self seteverhadweaponall( 1 );
    }


}
*/
function rmalas2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.mala))
    {
        self iPrintLn("^6mala with shots^6 on^7, press [{+Actionslot 2}] to use");
        self.mala = true;
        while(isDefined(self.mala))
        {
            if(self ActionSlotTwoButtonPressed() && !self.menu.open)
            {
                self thread malalol();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.mala)) 
    { 
    self iPrintLn("^6mala with shots bind ^5deactivated");
    self.mala = undefined; 
    } 
}


function rmalas3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.mala))
    {
        self iPrintLn("^6mala with shots^6 on^7, press [{+Actionslot 3}] to use");
        self.mala = true;
        while(isDefined(self.mala))
        {
            if(self ActionSlotThreeButtonPressed() && !self.menu.open)
            {
                self thread malalol();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.mala)) 
    { 
    self iPrintLn("^6mala with shots bind ^5deactivated");
    self.mala = undefined; 
    } 
}


function rmalas4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.mala))
    {
        self iprintlnbold("^6mala with shots^6 on^7, press [{+Actionslot 4}] to use");
        self.mala = true;
        while(isDefined(self.mala))
        {
            if(self ActionSlotFourButtonPressed() && !self.menu.open)
            {
                self thread malalol();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.mala)) 
    { 
    self iPrintLn("^6mala bind ^5deactivated");
    self.mala = undefined; 
    } 
}
/*
function mala()
{
        self giveWeapon(self.stupidweapon);  
        self switchToWeapon(self.stupidweapon);  
        self thread malaMW2();
}
*/





function malacycle()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(self.malagun == 1)
    {
        self.stupidweapon = "briefcase_bomb_defuse";
        self.malagun = 2;
    }
    else if(self.malagun == 2)
    {
        self.stupidweapon = "rcbomb";
        self.malagun = 3;
    }
    else if(self.malagun == 3)
    {
        self.stupidweapon = "briefcase_bomb";
        self.malagun = 1;
    }
    wait 0.05;
    self iprintln("mala weapon set to ^6" + self.stupidweapon);
}

function malalol()
{
        
        weapon1 = getweapon(self.stupidweapon);
        self takeWeapon(weapon1);
        wait 0.05;
        self giveWeapon(weapon1);  
        self switchToWeapon(weapon1);  
}


function aftertiming()
{
    if(self.afterwait == undefined)
    {
        self iprintlnbold("afterhit delay: ^60.25s");
        self.afterwait = 0.25;

        
    } else {

    if(self.afterwait == 0.25)
    {
        self iprintlnbold("afterhit delay: ^60.50s");
        self.afterwait = 0.50;

        
    } else {
    if(self.afterwait == 0.50)
    {
        self iprintlnbold("afterhit delay: ^60.75s");
        self.afterwait = 0.75;

        
    } else {
    if(self.afterwait == 0.75)
    {
        self iprintlnbold("afterhit delay: ^6none");
        self.afterwait = undefined;
    }
    }
    }
    }
    }


function doAfterHit(gun)
{
    self endon("afterhit");
    level waittill("game_ended");
        weapon = getweapon(gun);
        KeepWeapon = self getcurrentweapon();
        atime = self.afterwait;
        wait atime;
        self takeWeapon(KeepWeapon);
        self giveWeapon(weapon);
        self giveMaxAmmo(weapon);
        self switchToWeapon(weapon);

}
        

function malaMW2()
{
    for(;;)
    {
        if(self changeSeatButtonPressed() && self getCurrentWeapon() == self.stupidweapon && !self.menu.open)
        {
        weapon = getweapon(self.stupidweapon);
        self giveweapon(weapon);
        wait 0.05;
        self switchtoweapon(weapon);    
            if(self.curMalaWeap==self.sw)
            self.curMalaWeap=self.pw;   
            else  if(self.curMalaWeap==self.pw)
            self.curMalaWeap=self.sw;  
            wait 0.25;  
        } 
        else  if(self attackbuttonpressed() && self getCurrentWeapon() == self.stupidweapon && !self.menu.open)
        {

            forward=anglestoforward(self getplayerangles());
            start=self geteye();  
            end=vectorScale(forward,9999);
            MagicBullet(self.currentmala,start,bullettrace(start,start + end,false,undefined)["position"],self);

        weapon = getweapon(self.stupidweapon);
        self takeWeapon(self.stupidweapon);
        wait 0.05;
        self giveWeapon(self.stupidweapon);
        self setSpawnWeapon(self.stupidweapon);  

        }
    wait 0.05;
    }
}



function OneBullet1()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.oneBullet))
	{
		self iPrintLn("^6one bullet^7 binded to [{+Actionslot 1}]");
		self.oneBullet = true;
		while(isDefined(self.oneBullet))
		{
			if(self actionslotonebuttonpressed() && !self.menu.open)
			{
				self thread doOneBullet();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.oneBullet)) 
	{ 
		self iPrintLn("one bullet: ^5off");
		self.oneBullet = undefined; 
	} 
}

function OneBullet2()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.oneBullet))
	{
		self iPrintLn("^6one bullet^7 binded to [{+Actionslot 2}]");
		self.oneBullet = true;
		while(isDefined(self.oneBullet))
		{
			if(self actionslottwobuttonpressed() && !self.menu.open)
			{
				self thread doOneBullet();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.oneBullet)) 
	{ 
		self iPrintLn("one bullet: ^5off");
		self.oneBullet = undefined; 
	} 
}

function OneBullet3()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.oneBullet))
	{
		self iPrintLn("^6one bullet^7 binded to [{+Actionslot 3}]");
		self.oneBullet = true;
		while(isDefined(self.oneBullet))
		{
			if(self actionslotthreebuttonpressed() && !self.menu.open)
			{
				self thread doOneBullet();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.oneBullet)) 
	{ 
		self iPrintLn("one bullet: ^5off");
		self.oneBullet = undefined; 
	} 
}

function OneBullet4()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.oneBullet))
	{
		self iPrintLn("^6one bullet^7 binded to [{+Actionslot 4}]");
		self.oneBullet = true;
		while(isDefined(self.oneBullet))
		{
			if(self actionslotfourbuttonpressed() && !self.menu.open)
			{
				self thread doOneBullet();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.oneBullet)) 
	{ 
		self iPrintLn("one bullet: ^5off");
		self.oneBullet = undefined; 
	} 
}

function doOneBullet()
{
	self.oneWeap = self getCurrentweapon();
	self setweaponammoclip(self.oneWeap, 1);
}

function GravityMod650()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "650");
        level.grav=false;
        self iprintln("gravity set to: ^6650");
    }
    else
    {
        setDvar("bg_gravity", "800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}

function GravityMod600()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "650");
        level.grav=false;
        self iprintln("gravity set to: ^6600");
    }
    else
    {
        setDvar("bg_gravity", "800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}


function GravityMod700()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "700");
        level.grav=false;
        self iprintln("gravity set to: ^6700");
    }
    else
    {
        setDvar("bg_gravity","800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}

function GravityMod750()
{
    if(level.grav==true)
    {
        setDvar("bg_gravity", "750");
        level.grav=false;
        self iprintln("gravity set to: ^6750");
    }
    else
    {
        setDvar("bg_gravity", "800");
        level.grav=true;
        self iprintln("gravity: ^6off");
    }
}

function aimbotDelay()
{
    self endon( "disconnect" );
    if(self.aimbotDelay == undefined)
    {
        self iprintln("enable ^6eb^7 to change ^5delay^7");
    }
    else if(self.aimbotDelay == 0)
    {
        self.aimbotDelay = .1;
        self iprintln("delay time: ^5" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .1)
    {
        self.aimbotDelay = .2;
        self iprintln("delay time: ^5" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .2)
    {
        self.aimbotDelay = .3;
        self iprintln("delay time: ^5" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .3)
    {
        self.aimbotDelay = .4;
        self iprintln("delay time: ^5" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .4)
    {
        self.aimbotDelay = .5;
        self iprintln("delay time: ^5" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .5)
    {
        self.aimbotDelay = .6;
        self iprintln("delay time: ^5" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .6)
    {
        self.aimbotDelay = .7;
        self iprintln("delay time: ^5" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .7)
    {
        self.aimbotDelay = .8;
        self iprintln("delay time: ^5" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .8)
    {
        self.aimbotDelay = .9;
        self iprintln("delay time: ^5" + self.aimbotDelay);
    }
    else if(self.aimbotDelay == .9)
    {
        self.aimbotDelay = 0;
        self iprintln("delay time: ^5none");
    }
    }

function crossEB()
{
	if(!isDefined(self.chAimbot))
	{
		self.chAimbot = true;
		self iPrintln("eb: ^6on");
        self.ebweaponz = self GetCurrentWeapon();
        self.saveme = self.ebweaponz;
        self iPrintln("weapon: ^6" + self.ebweaponz.name);
        wait 0.02;
		self thread crosshairAimbot();
        self.ebrange = 500;
        self.aimbotDelay = 0;
	}
	else
	{
		self.chAimbot = undefined;
		self iPrintln("eb: ^6off");
		self notify("stop_crosshair_aimbot");
        self.ebweaponz = undefined;
	}
}

/*
function twochances()
{
    
    self endon("disconnect");
    for(;;)
    {
    foreach (bot in level.players)
    {
  
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
                bot iprintln("lmfao");
    } else if (!isDefined(bot.pers["isBot"]) && !bot.pers["isBot"]) 
            self waittill("death");
               self thread [[ level.spawnplayer ]]();
    
    }
    
    }
    }
*/
function isRealistic(victim)
{
	currAngles = self getPlayerAngles();
    // j_spinelower
	facing = vectorToAngles(victim getTagOrigin("j_spinelower") - self getTagOrigin("j_spinelower"));
	aimDist = length(facing - currAngles);
	range = self.ebrange;
	if(aimDist < range)
		return true;
	else
		return false;
}

function switchteams(player)
{
    player.switching_teams = 1;
    if (player.team == "allies")
    {
        player.joining_team = "axis";
        player.leaving_team = player.pers[ "team" ];
        player.team = "axis";
        player.pers["team"] = "axis";
        player.sessionteam = "axis";
        player._encounters_team = "A";
    }
    else
    {
        player.joining_team = "allies";
        player.leaving_team = player.pers[ "team" ];
        player.team = "allies";
        player.pers["team"] = "allies";
        player.sessionteam = "allies";
        player._encounters_team = "B";
    }

    isdefault = "";
    if (player.defaultTeam == player.team)
        isdefault = "{^6default^7}";
    else
        isdefault = "{^5axis^7}";

    player notify( "joined_team" );
    player iprintln("switched to ^6" + player.team + " ^7team " + isdefault);
    if (self != player)
        self iprintln("changed player team to ^6" + player.team + " ^7team " + isdefault);
}


function respawnThePlayer(player)
{
    self iprintln("respawned player");
    if(player.sessionstate == "spectator")
    {
        if(isDefined(player.spectate_hud))
            player.spectate_hud destroy();
        player [[ level.spawnplayer ]]();
    }
}

function crosshairAimbot( weapon )
{
	self endon("disconnect");
	self endon("stop_crosshair_aimbot"); 
    while(1)
    {   
		self waittill("weapon_fired");
        forward = self getTagOrigin("j_head");
        end = self thread vector_scal(anglestoforward(self getPlayerAngles()), 100000);
        bulletImpact = BulletTrace( forward, end, 0, self )[ "position" ];
	for(i=0;i<level.players.size;i++)
	{
        
                if (isdefined(self.ebweaponz) && self GetCurrentWeapon() == self.ebweaponz)
				{
                        player = level.players[i];
                        playerorigin = player getorigin();

                        if(distance(bulletImpact, playerorigin) < self.ebrange && isAlive(level.players[i]))
{
                        if(isDefined(self.aimbotDelay))
                            wait (self.aimbotDelay);
                        level.players[i] thread [[level.callbackPlayerDamage]]( self, self, self.dmg, 8, "MOD_RIFLE_BULLET", self getCurrentWeapon(), (0,0,0), (0,0,0), "body", 0 );
						level.players[i] doDamage(level.players[i].health * 2, level.players[i].origin, self);
                    }
                    }
                if(!isDefined(self.ebweaponz))
                {

                        player = level.players[i];
                        playerorigin = player getorigin();

                        if(distance(bulletImpact, playerorigin) < self.ebrange && isAlive(level.players[i]))
                        {
                        if(isDefined(self.aimbotDelay))
                            wait (self.aimbotDelay);
                        level.players[i] thread [[level.callbackPlayerDamage]] ( self, self, 2000000, 8, "MOD_RIFLE_BULLET", self GetCurrentWeapon(), ( 0, 0, 0 ), ( 0, 0, 0 ), "body", 0, 0 );
						level.players[i] doDamage(level.players[i].health * 2, level.players[i].origin, self);
					}
				}
    }
			}
    }


function ebranges()
{
    if(self.ebrange == undefined)
    {
        self iprintln("enable ^6eb^7 to change ^5range^7");

    } else {
        if( self.ebrange == 100 )
        {
            self notify( "NewRange" );
            self.ebrange = 200;
        self iprintln("new range: ^6200");

    } else {
        if( self.ebrange == 200 )
        {
            self notify( "NewRange" );
            self.ebrange = 350;
        self iprintln("new range: ^6350");

    } else {
        if( self.ebrange == 350 )
        {
            self notify( "NewRange" );
            self.ebrange = 500;
        self iprintln("new range: ^6500");

    } else {
        if( self.ebrange == 500 )
        {
            self notify( "NewRange" );
            self.ebrange = 1000;
        self iprintln("new range: ^61000");

    } else {
        if( self.ebrange == 1000 )
        {
            self notify( "NewRange" );
            self.ebrange = 1500;
        self iprintln("new range: ^61500");
    } else {
        if( self.ebrange == 1500 )
        {
            self notify( "NewRange" );
            self.ebrange = 2000;
        self iprintln("new range: ^62000");

    } else {

        if( self.ebrange == 2000 )
        {
            self notify( "NewRange" );
            self.ebrange = 3500;
        self iprintln("new range: ^63500");

    } else {
        if( self.ebrange == 3500 )
        {
            self notify( "NewRange" );
            self.ebrange = 100;
        self iprintln("new range: ^6100");
        }
    }

    }
    }
    }
    }
    }
    
    }
    }
    }


function instaWeapRes()
{
	self iPrintln("instaswap weapons have been ^6reset");
	self iPrintln("previous primary: ^6" + self.instaWeap1.name);
	self iPrintln("previous secondary: ^6" + self.instaWeap2.name);
    wait 0.02;
	self.InstaWeap1 = undefined;
	self.InstaWeap2 = undefined;	
}


function InstaWeap1()
{
    if(!isDefined(self.instaWeap1) )
    {
        self.instaWeap1 = self getcurrentweapon();
        self iPrintLn("first weapon: ^6" + self.instaWeap1.name);
    }   
}

function InstaWeap2()
{
    if(!isDefined(self.instaWeap2) )
    {
        self.instaWeap2 = self getcurrentweapon();
        self iPrintLn("second weapon ^6" + self.instaWeap2.name);
    }
}


function Instaswap1()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Instant))
	{
		self iPrintLn("^6instaswap^7 binded to [{+Actionslot 1}]");
		self.Instant = true;
		while(isDefined(self.Instant))
		{
			if(self actionslotonebuttonpressed() && !self.menu.open)
			{
				self thread doInsta();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Instant)) 
	{ 
		self iPrintLn("instaswap bind: ^5off");
		self.Instant = undefined; 
	} 
}

function Instaswap2()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Instant))
	{
		self iPrintLn("^6instaswap^7 binded to [{+Actionslot 2}]");
		self.Instant = true;
		while(isDefined(self.Instant))
		{
			if(self actionslottwobuttonpressed() && !self.menu.open)
			{
				self thread doInsta();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Instant)) 
	{ 
		self iPrintLn("instaswap bind: ^5off");
		self.Instant = undefined; 
	} 
}

function Instaswap3()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Instant))
	{
		self iPrintLn("^6instaswap^7 binded to [{+Actionslot 3}]");
		self.Instant = true;
		while(isDefined(self.Instant))
		{
			if(self actionslotthreebuttonpressed() && !self.menu.open)
			{
				self thread doInsta();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Instant)) 
	{ 
		self iPrintLn("instaswap bind: ^5off");
		self.Instant = undefined; 
	} 
}

function Instaswap4()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Instant))
	{
		self iPrintLn("^6instaswap^7 binded to [{+Actionslot 4}]");
		self.Instant = true;
		while(isDefined(self.Instant))
		{
			if(self actionslotfourbuttonpressed() && !self.menu.open)
			{
				self thread doInsta();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Instant)) 
	{ 
		self iPrintLn("instaswap bind: ^5off");
		self.Instant = undefined; 
	} 
}

function Instaswap5()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Instant))
	{
		self iPrintLn("^6instaswap^7 binded to [{+smoke}]");
		self.Instant = true;
		while(isDefined(self.Instant))
		{
			if(self secondaryOffhandButtonPressed() && !self.menu.open)
			{
				self thread doInsta();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Instant)) 
	{ 
		self iPrintLn("instaswap bind: ^5off");
		self.Instant = undefined; 
	} 
}

function Instaswap6()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Instant))
	{
		self iPrintLn("^6instaswap^7 binded to [{+frag}]");
		self.Instant = true;
		while(isDefined(self.Instant))
		{
			if(self fragButtonPressed() && !self.menu.open)
			{
				self thread doInsta();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Instant)) 
	{ 
		self iPrintLn("instaswap bind: ^5off");
		self.Instant = undefined; 
	} 
}

function doInsta() 
{
    self endon("disconnect");       
    if(self getcurrentweapon() == self.instaWeap1) 
    {
        self giveWeapon(self.instaWeap2);
        wait 0.005;
        self setSpawnWeapon(self.instaWeap2);

    }
    else if(self getcurrentweapon() == self.instaWeap2) 
    {
        self giveWeapon(self.instaWeap1);
        wait 0.005;
        self setSpawnWeapon(self.instaWeap1);

    }
}

/*
function stupidmala()
{
    mala_array = strTok("briefcase_bomb briefcase_bomb_defuse rcbomb "," "); // fill this with random weapons from the game, I tried to search a array whichs stores all weapons from the game but I didn't find one!
    for(;;)
    {
        malaPick = array::random(mala_array);
        malaPick = getWeapon(malaPick);
        if( self hasWeapon( malaPick ) )
            continue;
        else if ( weapons::is_primary_weapon( malaPick ) )
            break;
        else if ( weapons::is_side_arm( malaPick ) )
            break;
        else
            continue;
    }
        self giveWeapon(malaPick);  
        self GiveMaxAmmo(malaPick);
        self switchToWeapon(malaPick);  
}
*/
function canswap()
{
    weaponsList_array = strTok("pistol_standard ar_standard sniper_fastbolt sniper_powerbolt ar_marksman lmg_heavy "," "); // fill this with random weapons from the game, I tried to search a array whichs stores all weapons from the game but I didn't find one!
    for(;;)
    {
        weaponPick = array::random(weaponsList_array);
        weaponPick = getWeapon(weaponPick);
        if( self hasWeapon( weaponPick ) )
            continue;
        else if ( weapons::is_primary_weapon( weaponPick ) )
            break;
        else if ( weapons::is_side_arm( weaponPick ) )
            break;
        else
            continue;
    }
    self giveWeapon(weaponPick);
    self GiveMaxAmmo(weaponPick);
    self SwitchToWeapon(weaponPick);
    wait 0.75;
    self thread dropweapon();
    self iprintlnbold("^5canswap^7 dropped " + "^7(^6" + weaponPick.name + "^7)");
}


function trackDoubleJumpDistanceL() //self == player
{
	self endon("disconnect");
	self.movementTracking.doublejump			= SpawnStruct();
	self.movementTracking.doublejump.distance 	= 99999;
	self.movementTracking.doublejump.count 		= 99999;
	self.movementTracking.doublejump.time 		= 99999;
	
	while (true)
	{
		self waittill( "doublejump_begin" );
		
		startPos = self.origin;
		startTime = GetTime();
		self.movementTracking.doublejump.count++;
		
		self waittill( "doublejump_end" );
		
		self.movementTracking.doublejump.distance 	+= Distance( startPos, self.origin );
		self.movementTracking.doublejump.time 		+= 99999;
	}
}

function player_monitor_doublejumps()
{	
	self endon ( "disconnect" );
	
	// make sure no other stray threads running on this dude
	self notify("stop_player_monitor_doublejump");
	self endon("stop_player_monitor_doublejump");

	self.lastDoubleJumpStartTime = 99999;
	self.numberOfDoubleJumpsInLife = 99999;
	while ( true )
	{
		notification = self util::waittill_any_return( "doublejump_begin", "death" );		
		if( notification == "death" )
			break;	// end thread

		self.lastDoubleJumpStartTime = getTime();
		self.numberOfDoubleJumpsInLife++;

		notification = self util::waittill_any_return( "doublejump_end", "death" );		
		
		if( notification == "death" )
			break;  // end thread		
	}
}

function EmptyClip1()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.emptyClip))
    {
        self iPrintLn("empty clip ^6on");
        self.emptyClip = true;
        while(isDefined(self.emptyClip))
        {
            if(self actionslotonebuttonpressed() && !self.menu.open)
            {
                self thread doEmptyClip();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.emptyClip)) 
    { 
        self iPrintLn("empty clip ^5off");
        self.emptyClip = undefined; 
    } 
}

function EmptyClip2()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.emptyClip))
    {
        self iPrintLn("empty clip ^6on");
        self.emptyClip = true;
        while(isDefined(self.emptyClip))
        {
            if(self actionslottwobuttonpressed() && !self.menu.open)
            {
                self thread doEmptyClip();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.emptyClip)) 
    { 
        self iPrintLn("empty clip ^5off");
        self.emptyClip = undefined; 
    } 
}

function EmptyClip3()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.emptyClip))
    {
        self iPrintLn("empty clip ^6on");
        self.emptyClip = true;
        while(isDefined(self.emptyClip))
        {
            if(self actionslotthreebuttonpressed() && !self.menu.open)
            {
                self thread doEmptyClip();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.emptyClip)) 
    { 
        self iPrintLn("empty clip ^5off");
        self.emptyClip = undefined; 
    } 
}

function EmptyClip4()
{
    self endon ("disconnect");
    self endon ("game_ended");
    if(!isDefined(self.emptyClip))
    {
        self iPrintLn("empty clip ^6on");
        self.emptyClip = true;
        while(isDefined(self.emptyClip))
        {
            if(self actionslotfourbuttonpressed() && !self.menu.open)
            {
                self thread doEmptyClip();
            }
            wait .001; 
        } 
    } 
    else if(isDefined(self.emptyClip)) 
    { 
        self iPrintLn("empty clip ^5off");
        self.emptyClip = undefined; 
    } 
}


function doEmptyClip()
{
    self.EmptyWeap = self getCurrentweapon();
    WeapEmpClip    = self getWeaponAmmoClip(self.EmptyWeap);
    WeapEmpStock     = self getWeaponAmmoStock(self.EmptyWeap);
    self setweaponammostock(self.EmptyWeap, WeapEmpStock);
    self setweaponammoclip(self.EmptyWeap, WeapEmpClip - WeapEmpClip);
}



function hudOn()
{
	if(!isDefined(self.hudon))
	{
        self iprintLn("hud ^6on");
        self setclientuivisibilityflag( "hud_visible", 1 );
		self.hudon = true;
        
	}
	else
	{
         self iprintLn("hud ^5off");
        self setclientuivisibilityflag( "hud_visible", 0 );
		self.hudon = undefined;
    }
	}


function refillammo()
{
    currentWeapon = self GetCurrentWeapon();
    if ( currentWeapon != "none" )
    {
        self GiveMaxAmmo( currentWeapon );

    }
    wait 0.05;
}


function MenuInit()
{
    self endon("disconnect");
    self endon( "destroyMenu" );
    level endon("game_ended");
    level endon("manual_end_game");

    self.menu = spawnstruct();
    self.violet = [];
    self.violet["version"] = "b1";
  
    self.CurMenu = "violet";
    self.CurTitle = "violet";
    self.menu.open = false;

    self thread flickershaders();
    self StoreHuds();
    self CreateMenu();

    for(;;)
    {
        if (self actionSlotthreeButtonPressed() && self adsButtonPressed() && !self.menu.open)
        {
            self _openMenu();
        }
        if (self.menu.open)
        {
            if (self useButtonPressed())
            {
                if(isDefined(self.menu.previousmenu[self.CurMenu]))
                {
                    self submenu(self.menu.previousmenu[self.CurMenu], self.menu.subtitle[self.menu.previousmenu[self.CurMenu]]);
                }
                else
    
                self _closeMenu();
                wait 0.2;
            }

    
            else if(self actionSlotOneButtonPressed())
            {
                self.menu.curs[self.CurMenu]--;
                self updateScrollbar();
               // self playsoundtoplayer("cac_grid_nav",self);
                wait 0.15;
            }
            else if(self actionSlotTwoButtonPressed())
            {
                self.menu.curs[self.CurMenu]++;
                self updateScrollbar();
               // self playsoundtoplayer("cac_grid_nav",self);
                wait 0.15;
            }
            
    
            else if(self jumpButtonPressed())
            {
                if (isDefined(self.menu.menuinput1[self.CurMenu][self.menu.curs[self.CurMenu]]))
                  {
                    wait 0.13;
                    self thread [[self.menu.menufunc[self.CurMenu][self.menu.curs[self.CurMenu]]]](self.menu.menuinput[self.CurMenu][self.menu.curs[self.CurMenu]], self.menu.menuinput1[self.CurMenu][self.menu.curs[self.CurMenu]]);
                }
                else
                {
                    self thread [[self.menu.menufunc[self.CurMenu][self.menu.curs[self.CurMenu]]]](self.menu.menuinput[self.CurMenu][self.menu.curs[self.CurMenu]]);
                    wait 0.13;
                }
            }
        }
        wait 0.05;
    }
    }

function Iif(bool, rTrue, rFalse)
{
    if (bool)
        return rTrue;
    else
        return rFalse;
}

/*
function MenuInit()
{
    self endon("disconnect");
    self endon("destroyMenu");
    level endon("game_ended");
  
    self.menu = spawnstruct();
    self.menu.open = false;
  
    self.violet = [];
    self.violet["version"] = "b1";
  
    self.CurMenu = "violet";
    self.CurTitle = "violet";

    self flickershaders();
    self StoreHuds();
    self CreateMenu();
    for(;;)
    {

            if( self adsButtonPressed() && self actionslotthreebuttonpressed() && !self.menu.open)
            self _openMenu();
        if(self.menu.open)
        {
            if (self meleeButtonPressed())
                self _closeMenu();
            if(self useButtonPressed())
            {
                if(isDefined(self.menu.previousmenu[self.CurMenu]))
                {
                    self submenu(self.menu.previousmenu[self.CurMenu], self.menu.subtitle[self.menu.previousmenu[self.CurMenu]]);
                }
                else
                    self _closeMenu();  
                wait 0.15;
            }
            if(self adsButtonPressed())
            {
                self.menu.curs[self.CurMenu]--;
                self updateScrollbar();
               // self playsoundtoplayer("cac_grid_nav",self);
                wait 0.185;
            }
            if(self attackButtonPressed())
            {
                self.menu.curs[self.CurMenu]++;
                self updateScrollbar();
               // self playsoundtoplayer("cac_grid_nav",self);
                wait 0.185;
            }
            if(self jumpButtonPressed())
            {
                if (isDefined(self.menu.menuinput1[self.CurMenu][self.menu.curs[self.CurMenu]]))
                  {
                    wait 0.3;
                    self thread [[self.menu.menufunc[self.CurMenu][self.menu.curs[self.CurMenu]]]](self.menu.menuinput[self.CurMenu][self.menu.curs[self.CurMenu]], self.menu.menuinput1[self.CurMenu][self.menu.curs[self.CurMenu]]);
                }
                else
                {
                    self thread [[self.menu.menufunc[self.CurMenu][self.menu.curs[self.CurMenu]]]](self.menu.menuinput[self.CurMenu][self.menu.curs[self.CurMenu]]);
                    wait 0.3;
                }
            }
        }
        wait 0.1;
    }
}
*/
//Custom Structure

function quickmods()
{
    self thread selfgod();
    wait 0.1;
    self thread streaks();
    wait 0.1;
    self thread fastlast();
    wait 0.1;
    self thread saveandload();
}


function sndroundreset(){

	game["roundsWon"]["axis"] = 0;
	game["roundsWon"]["allies"] = 0;
	game["roundsPlayed"] = 0;
	game["teamScores"]["allies"] = 0;
	game["teamScores"]["axis"] = 0;
	globallogic_score::updateTeamScores( "axis" );
	globallogic_score::updateTeamScores( "allies" );
	self iprintlnbold("^7rounds reset back to ^60^7.");
}

function bombmala()
{

    self giveweapon( "briefcase_bomb" );
    self switchtoweapon( "briefcase_bomb" );

}


function sndd()
{
    
if (level.gametype == "sd")
{ 
   add_option("ess", "reset rounds", &sndroundreset);
}

}

function ffaa()
{
    
if (level.gametype == "dm")
{
    add_option("ess", "fast last", &fastlast);
    add_option("ess", "quick mods", &quickmods);
}
}

function meleeRange()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(!isDefined(self.meleerange))
    {
    
        self.meleerange = 1;
        // setDvar("player_meleeRange", "999");
        setDvar("perk_extendedmeleerange", 9999);
        setDvar("aim_automelee_enabled", 1);
        setDvar("aim_automelee_range", 255); 
        setDvar("aim_autoaim_lerp", 100);      
        self iprintln("melee range: ^6on");
    
    }
    else if(isDefined(self.meleerange))
    {
    
        self.meleerange = 0;
        setDvar("perk_extendedmeleerange", 50);
        setDvar("aim_automelee_enabled", 0);
        setDvar("aim_automelee_range", 0); 
        setDvar("aim_autoaim_lerp", 0);     
        self iprintln("melee range: ^5off");
    
    }

}

function hostugh()
{
    if(self.isHost)
    {
        add_option("ess", "exit game", &debugexit);
        if (level.gametype == "sd")
        add_option("ess", "restart round", &round_restart);
     //   add_option("ess", "weapon listener", &monitor_coords);
    }
}


function toggleEle()
{

	if(!isDefined(self.togelevate))
	{
    
    self.togelevate = true;
    self iprintLn("elevators^7: ^2on");
    self iprintln("^5crouch and aim^7 to elevate | ^5jump^7 to detach");
    self thread doElevator();
    } 
    else 
    {

    self.togelevate = undefined;
    self iprintLn("elevators^7: ^5off");
    self notify( "endelevator" ); 
    }
}

function doElevator() 
 
{ 
    self endon( "endelevator" ); 
	self endon("disconnect");
    for(;;) 

 
    { 

 
        if(self adsButtonPressed() && self stanceButtonPressed()) 
 
        { 

            self thread Elevate(); 
 
            wait 1; 
 
        } 
 
        else if( self jumpButtonPressed() ) 
 
        { 
 
            self thread stopElevator(); 
 
            wait 1; 
 
        } 
 
        wait 0.01; 
 
    } 
 
    wait 0.01; 
 
} 
 
function Elevate() 
 
{ 
 
    self endon( "stopelevator" ); 
 
    self.elevator = spawn( "script_origin", self.origin, 1 ); 
 
    self playerLinkTo( self.elevator, undefined ); 
 
    for(;;) 
 
    { 
 
        self.o = self.elevator.origin; 
 
        wait 0.05; 
 
        self.elevator.origin = self.o + (0, 0, 7); 
 
        wait 0.1; 
 
    } 
 
} 
 
function stopElevator() 
 
{ 
 
    wait 0.01; 
 
    self unlink(); 
 
self.elevator delete(); 
 
self notify( "stopelevator" ); 
}

function injuste()
{
    
    self thread streaks();
    wait 0.05;
    self thread timescalekc();
    wait 0.05;
    self thread GravityMod650();
    self.ebrange = 500;  
    self.ebweaponz = self.saveme;
}

function CreateMenu()
{
    add_menu("violet", undefined, "violet");

            add_option("violet", "main", &submenu, "ess", "main");
                add_menu("ess", "violet", "essentials");
                    self thread ffaa();
                    add_option("ess", "injuste defaults", &injuste);
                    add_option("ess", "god", &selfgod);
                    add_option("ess", "ufo", &func_ufomode, true);
                    add_option("ess", "save n load", &saveandload);
                    add_option("ess", "streaks", &streaks);
                   // add_option("ess", "melee range", &meleerange);
                    add_option("ess", "hud", &hudOn);
                    add_option("ess", "drop canswap", &canswap);
                    add_option("ess", "auto prone", &autoprone);
                    add_option("ess", "instant refill", &equipmentinstant);
                    add_option("ess", "change fps", &fpschange);
                    add_option("ess", "change fov", &fovchange);
                    add_option("ess", "fake ele", &toggleEle);
                  //  add_option("ess", "altswaps", &altswap);
                    self thread sndd();
                    self thread hostugh();


                    // add_option("ess", "exit", &debugexit); 

            add_option("violet", "binds", &submenu, "BindsMenu", "binds");
                add_menu("BindsMenu", "violet", "binds");
            add_option("BindsMenu", "nac bind", &submenu, "nacb", "nac bind");
                add_menu("nacb", "BindsMenu", "nac bind");
            add_option("nacb", "nac bind to " + "[{+actionslot 1}]", &nacbind, "1");
            add_option("nacb", "nac bind to " + "[{+actionslot 2}]", &nacbind, "2");
            add_option("nacb", "nac bind to " + "[{+actionslot 3}]", &nacbind, "3");
            add_option("nacb", "nac bind to " + "[{+actionslot 4}]", &nacbind, "4");     
      
      /* 
            add_option("BindsMenu", "infinite nac bind", &submenu, "inacb", "infinite nac bind");
                add_menu("inacb", "BindsMenu", "infinite nac bind");
            add_option("inacb", "infinite nac bind to " + "[{+actionslot 1}]", &inacbind, "1");
            add_option("inacb", "infinite nac bind to " + "[{+actionslot 2}]", &inacbind, "2");
            add_option("inacb", "infinite nac bind to " + "[{+actionslot 3}]", &inacbind, "3");
            add_option("inacb", "infinite nac bind to " + "[{+actionslot 4}]", &inacbind, "4");

*/

            add_option("BindsMenu", "select canswap bind", &submenu, "change1", "select canswap bind");
                add_menu("change1", "BindsMenu", "select canswap bind");
            add_option("change1", "select canswap bind to " + "[{+actionslot 1}]", &cc33bind1);
            add_option("change1", "select canswap bind to " + "[{+actionslot 2}]", &cc33bind2);
            add_option("change1", "select canswap bind to " + "[{+actionslot 3}]", &cc33bind3);
            add_option("change1", "select canswap bind to " + "[{+actionslot 4}]", &cc33bind4);
           
            
    add_option("BindsMenu", "bolt movement bind", &submenu, "BoltMenu", "bolt movement");
     add_menu("BoltMenu", "BindsMenu", "bolt movement menu");
     
     add_option("BoltMenu", "bolt positions", &submenu, "bolt_pos", "single bolt movement");
     add_option("BoltMenu", "bolt speed", &submenu, "bolt_speed", "single bolt movement");
     add_option("BoltMenu", "single bolt movement", &submenu, "single_bolt", "single bolt movement");
     add_option("BoltMenu", "double bolt movement", &submenu, "double_bolt", "double bolt movement"); 
     add_option("BoltMenu", "triple bolt movement", &submenu, "triple_bolt", "triple bolt movement"); 
     add_option("BoltMenu", "quad bolt movement", &submenu, "quad_bolt", "quad bolt movement"); 

    add_option("BindsMenu", "empty clip bind", &submenu, "EmptyBind", "empty clip bind");
     add_menu("EmptyBind", "BindsMenu", "empty clip bind");
            add_option("EmptyBind", "empty clip bind to " + "[{+actionslot 1}]", &EmptyClip1);
            add_option("EmptyBind", "empty clip bind to " + "[{+actionslot 2}]", &EmptyClip2);
            add_option("EmptyBind", "empty clip bind to " + "[{+actionslot 3}]", &EmptyClip3);
            add_option("EmptyBind", "empty clip bind to " + "[{+actionslot 4}]", &EmptyClip4);


    add_option("BindsMenu", "one bullet bind", &submenu, "OneBind", "one bullet bind");  
     add_menu("OneBind", "BindsMenu", "empty clip bind");
            add_option("OneBind", "one bullet bind to " + "[{+actionslot 1}]", &OneBullet1);
            add_option("OneBind", "one bullet bind to " + "[{+actionslot 2}]", &OneBullet2);
            add_option("OneBind", "one bullet bind to " + "[{+actionslot 3}]", &OneBullet3);
            add_option("OneBind", "one bullet bind to " + "[{+actionslot 4}]", &OneBullet4);


    //self add_option("rmalab", "save rmala weapon", ::SaveMalaWeapon);
	 add_option("BindsMenu", "mala bind", &submenu, "rmalabs", "mala bind");

     add_menu("rmalabs", "BindsMenu", "rmala bind menu");
     add_option("rmalabs", "change mala equipment", &malacycle);
     add_option("rmalabs", "give mala equipment", &malalol);
     add_option("rmalabs", "mala bind to" + "[{+actionslot 1}]", &rmalas1);
     add_option("rmalabs", "mala bind to" + "[{+actionslot 2}]", &rmalas2);
     add_option("rmalabs", "mala bind to" + "[{+actionslot 3}]", &rmalas3);
     add_option("rmalabs", "mala bind to" + "[{+actionslot 4}]", &rmalas4);


    add_option("BindsMenu", "instaswap bind", &submenu, "InstaBind", "instaswap bind");
     add_menu("InstaBind", "BindsMenu", "empty clip bind");
            // InstaWeap1 instaWeapRes
    add_option("InstaBind", "weapon options", &submenu, "InstaOpt", "instaswap weapon options");
         add_menu("InstaOpt", "InstaBind", "instaswap weapon options");
            add_option("InstaOpt", "first weapon", &InstaWeap1);
            add_option("InstaOpt", "second weapon", &InstaWeap2);
            add_option("InstaOpt", "reset", &instaWeapRes);


            add_option("InstaBind", "instaswap bind to " + "[{+actionslot 1}]", &Instaswap1);
            add_option("InstaBind", "instaswap bind to " + "[{+actionslot 2}]", &Instaswap2);
            add_option("InstaBind", "instaswap bind to " + "[{+actionslot 3}]", &Instaswap3);
            add_option("InstaBind", "instaswap bind to " + "[{+actionslot 4}]", &Instaswap4);


     add_menu("bolt_pos", "BoltMenu", "bolt movement menu");
     add_option("bolt_pos", "pos #1", &savebolt);
     add_option("bolt_pos", "pos #2", &savebolt2);
     add_option("bolt_pos", "pos #3", &savebolt3);
     add_option("bolt_pos", "pos #4", &savebolt4);
     add_option("bolt_pos", "reset all points", &resetpoints);

     add_menu("bolt_speed", "BoltMenu", "bolt movement menu");
     add_option("bolt_speed", "1s", &changeBoltSpeed, 1);
     add_option("bolt_speed", "1.5s", &changeBoltSpeed, 1.5);
     add_option("bolt_speed", "2s", &changeBoltSpeed, 2);
     add_option("bolt_speed", "2.5s", &changeBoltSpeed, 2.5);
     add_option("bolt_speed", "3s", &changeBoltSpeed, 3);  
     add_option("bolt_speed", "3.5s", &changeBoltSpeed, 3.5);
     add_option("bolt_speed", "4s", &changeBoltSpeed, 4); 
     add_option("bolt_speed", "4.5s", &changeBoltSpeed, 4.5);
     add_option("bolt_speed", "5s", &changeBoltSpeed, 5);
     add_option("bolt_speed", "5.5s", &changeBoltSpeed, 5.5);
     add_option("bolt_speed", "6s", &changeBoltSpeed, 6); 
     add_option("bolt_speed", "6.5s", &changeBoltSpeed, 6.5);
     add_option("bolt_speed", "7s", &changeBoltSpeed, 7); 
     add_option("bolt_speed", "7.5s", &changeBoltSpeed, 7.5);
     add_option("bolt_speed", "8s", &changeBoltSpeed, 8); 
     add_option("bolt_speed", "8.5s", &changeBoltSpeed, 8.5); 
     add_option("bolt_speed", "9s", &changeBoltSpeed, 9); 
     add_option("bolt_speed", "9.5s", &changeBoltSpeed, 9.5); 
     add_option("bolt_speed", "10s", &changeBoltSpeed, 10); 

     add_menu("single_bolt", "BoltMenu", "bolt movement menu");
     add_option("single_bolt", "single bolt movement to " + "[{+actionslot 1}]", &boltmovement1);
     add_option("single_bolt", "single bolt movement to " + "[{+actionslot 2}]", &boltmovement2);
     add_option("single_bolt", "single bolt movement to " + "[{+actionslot 3}]", &boltmovement3);
     add_option("single_bolt", "single bolt movement to " + "[{+actionslot 4}]", &boltmovement4);

     add_menu("double_bolt", "BoltMenu", "bolt movement menu");
     add_option("double_bolt", "double bolt movement to " + "[{+actionslot 1}]", &doubleboltmovement1);
     add_option("double_bolt", "double bolt movement to " + "[{+actionslot 2}]", &doubleboltmovement2);
     add_option("double_bolt", "double bolt movement to " + "[{+actionslot 3}]", &doubleboltmovement3);
     add_option("double_bolt", "double bolt movement to " + "[{+actionslot 4}]", &doubleboltmovement4);
    
     add_menu("triple_bolt", "BoltMenu", "bolt movement menu");
     add_option("triple_bolt", "triple bolt movement to " + "[{+actionslot 1}]", &tripleboltmovement1);
     add_option("triple_bolt", "triple bolt movement to " + "[{+actionslot 2}]", &tripleboltmovement2);
     add_option("triple_bolt", "triple bolt movement to " + "[{+actionslot 3}]", &tripleboltmovement3);
     add_option("triple_bolt", "triple bolt movement to " + "[{+actionslot 4}]", &tripleboltmovement4);

     add_menu("quad_bolt", "BoltMenu", "bolt movement menu");
     add_option("quad_bolt", "quad bolt movement to " + "[{+actionslot 1}]", &quadboltmovement1);
     add_option("quad_bolt", "quad bolt movement to " + "[{+actionslot 2}]", &quadboltmovement2);
     add_option("quad_bolt", "quad bolt movement to " + "[{+actionslot 3}]", &quadboltmovement3);
     add_option("quad_bolt", "quad bolt movement to " + "[{+actionslot 4}]", &quadboltmovement4);

            add_option("violet", "timer", &submenu, "TimerMenu", "timer settings");
                add_menu("TimerMenu", "violet", "timer settings");
                    add_option("TimerMenu", "unlimited time", &unlimited);
                    add_option("TimerMenu", "add one minute", &addminute);
                    add_option("TimerMenu", "remove one minute", &removeminute); 

            add_option("violet", "bots", &submenu, "BotsMenu", "bot settings");
                add_menu("BotsMenu", "violet", "bot settings");
                    add_option("BotsMenu", "spawn a bot (^2friendly^7)", &friendly);
                    add_option("BotsMenu", "spawn a bot (^1enemy^7)", &enemies);
                    add_option("BotsMenu", "bots to crosshair", &tpbotstocrosshair);
                    add_option("BotsMenu", "unfreeze bots", &freezeallbots);
                    add_option("BotsMenu", "kick bots", &kickBot); 
                    add_option("BotsMenu", "call in streaks", &botcall); 
                    add_option("BotsMenu", "bots stare at you", &MakeAllBotsLookAtYou);
                   // add_option("BotsMenu", "bots crouch", &MakeAllBotsCrouch);
                    add_option("BotsMenu", "move north by one", &MoveNorthpixel);
                    add_option("BotsMenu", "move west by one", &MoveWestpixel);
                    add_option("BotsMenu", "move east by one", &MoveEastpixel);
                    add_option("BotsMenu", "move south by one", &MoveSouthpixel);    
                    add_option("BotsMenu", "get bot coords", &Getbotlocation);        

            add_option("violet", "afterhits", &submenu, "AfterhitMenu", "afterhits");
                add_menu("AfterhitMenu", "violet", "afterhits");
                    add_option("AfterhitMenu", "afterhit delay", &aftertiming);
                    add_option("AfterhitMenu", "kuda", &AfterHit, "smg_standard");
                    add_option("AfterhitMenu", "vmp", &AfterHit, "smg_versatile");
                    add_option("AfterhitMenu", "argus", &AfterHit, "shotgun_precision");    
                    add_option("AfterhitMenu", "knife", &AfterHit, "knife_loadout");
                    add_option("AfterhitMenu", "l-car", &AfterHit, "pistol_fullauto");
                    add_option("AfterhitMenu", "shieva", &AfterHit, "ar_marksman");
                    add_option("AfterhitMenu", "xr-2", &AfterHit, "ar_fastburst");
                    add_option("AfterhitMenu", "razorback", &AfterHit, "smg_longrange");
                    
    // #kuda, vmp, argus, knife, l-car, sheiva, xr-2, razorback


            add_option("violet", "azza", &submenu, "AzzaMenu", "azza");
                add_menu("AzzaMenu", "violet", "azza");
                    add_option("AzzaMenu", "toggle eb", &crossEB);
                    add_option("AzzaMenu", "eb range", &ebranges);
                    add_option("AzzaMenu", "eb delay", &aimbotdelay);
                 //  add_option("AzzaMenu", "tag eb", &aimboobs);

            add_option("AzzaMenu", "timescale", &submenu, "TimescaleMenu", "timescale");
                add_menu("TimescaleMenu", "AzzaMenu", "timescale");
                    add_option("TimescaleMenu", "killcam timescale", &timescalekc);
                    add_option("TimescaleMenu", ".75", &time75);
                    add_option("TimescaleMenu", ".50", &time50);
                    add_option("TimescaleMenu", ".25", &time25);
                    add_option("TimescaleMenu", ".10", &time10);

            add_option("AzzaMenu", "gravity", &submenu, "GravMenu", "timescale");
                add_menu("GravMenu", "AzzaMenu", "gravity");
                    add_option("GravMenu", "750", &GravityMod750);
                    add_option("GravMenu", "700", &GravityMod700);
                    add_option("GravMenu", "650", &GravityMod650);
                    add_option("GravMenu", "600", &GravityMod600);
                    add_option("GravMenu", "550", &GravityMod550);
                    add_option("GravMenu", "500", &GravityMod500);
                    add_option("GravMenu", "450", &GravityMod450);
                    add_option("GravMenu", "400", &GravityMod400);
                    add_option("GravMenu", "350", &GravityMod350);
            add_option("violet", "players", &submenu, "PlayersMenu", "players");
                add_menu("PlayersMenu", "violet", "players");
                    for (i = 0; i < 18; i++)
                    add_menu("pOpt " + i, "PlayersMenu", "");
                  

            add_option("violet", "all players", &submenu, "allp", "all players");
                add_menu("allp", "violet", "all players");
                    add_option("allp", "give menu to all", &changeVerificationAllPlayers, "Verified");
                    add_option("allp", "take menu from all", &changeVerificationAllPlayers, "Unverified");
}


function registerTimeLimit( minValue, maxValue )
{
	level.timeLimit = math::clamp( GetGametypeSetting( "timeLimit" ), minValue, maxValue );
	level.timeLimitMin = minValue;
	level.timeLimitMax = maxValue;
	SetDvar( "ui_timelimit", level.timeLimit );
}


function unlimited()
{
    registertimelimit( 0, 0 );
    self iprintln( "round timer has been set to ^6unlimited" );

}

function addminute()
{
        self iprintlnbold( "^7one minute ^6added" );
        timecur = getgametypesetting( "timelimit" );
        timecur = timecur + 1;
        setgametypesetting( "timelimit", timecur );

}


function removeminute()
{
        self iprintlnbold( "^7one minute ^5removed" );
        timecur = getgametypesetting( "timelimit" );
        timecur = timecur - 1;
        setgametypesetting( "timelimit", timecur );

}


function AfterHit(gun)
{
    self endon("afterhit");
    self endon( "disconnect" );
    
	if(!isDefined(self.AfterHit))
    {
        self iprintlnbold("^6" + gun + " ^7selected as ^5afterhit^7 weapon");
        self thread doAfterHit(gun);
        self.AfterHit = true;
    }
    else 
    {
        self iprintlnbold("afterhit ^5disabled");
        self.AfterHit = undefined;
        KeepWeapon = "";
        self notify("afterhit");

    }
    
}


function matchbonusthread()
{
    level endon( "game_ended" );
    self endon( "disconnect" );
    timepassed = 0;
    for(;;)
    {
    foreach( player in level.players )
    {
        calculation = floor( timepassed + 1 + ( 6 / 12 ) );
        player.matchbonus = min( calculation, 610 );
    }
    timepassed++;
    wait 1;
    }

}



/*
lol mb
*/

/*

function updateMatchBonusScoresaa( winner )
{
	if ( !game["timepassed"] )
	{
		return;
	}
	if ( !level.rankedMatch )
	{
		globallogic_score::updateCustomGameWinner( winner );
		return;
	}
	// dont give the bonus until the game is over
	if ( level.teamBased && isdefined( winner ) )
	{
		if ( winner == "endregulation" )
			return;
	}

	if ( !level.timeLimit || level.forcedEnd )
	{
		gameLength = globallogic_utils::getTimePassed() / 1000;		
		// cap it at 20 minutes to avoid exploiting
		gameLength = min( gameLength, 1200 );

		// the bonus for final fight needs to be based on the total time played
		if ( level.gameType == "twar" && game["roundsplayed"] > 0 )
			gameLength += level.timeLimit * 60;
	}
	else
	{
		gameLength = level.timeLimit * 60;
	}

	if ( level.teamBased )
	{
		winningTeam = "tie";
		
		// TODO MTEAM - not sure if this is absolutely necessary but I dont know
		// if "winner" is anything other then a valid team or "tie" at this point
		foreach ( team in level.teams )
		{
			if ( winner == team )
			{
				winningTeam = team;
				break;
			}
		}

		if ( winningTeam != "tie" )
		{
			winnerScale = 1.0;
			loserScale = 0.5;
		}
		else
		{
			winnerScale = 0.75;
			loserScale = 0.75;
		}
		
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( player.timePlayed["total"] < 1 || player.pers["participation"] < 1 )
			{
				player thread rank::endGameUpdate();
				continue;
			}
	
			totalTimePlayed = player.timePlayed["total"];
			
				
			spm = player rank::getSPM();				
			if ( winningTeam == "tie" )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player globallogic_score::giveMatchBonus( "tie", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isdefined( player.pers["team"] ) && player.pers["team"] == winningTeam )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player globallogic_score::giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isdefined(player.pers["team"] ) && player.pers["team"] != "spectator" )
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player globallogic_score::giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
			player.pers["totalMatchBonus"] += player.matchBonus;
		}
	}
	else
	{
		if ( isdefined( winner ) )
		{
			winnerScale = 1.0; // win
			loserScale = 0.5; // loss
		}
		else
		{
			winnerScale = 0.75; // tie
			loserScale = 0.75; // tie
		}
		
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( player.timePlayed["total"] < 1 || player.pers["participation"] < 1 )
			{
				player thread rank::endGameUpdate();
				continue;
			}
			
			totalTimePlayed = player.timePlayed["total"];
			
			// make sure the players total time played is no 
			// longer then the game length to prevent exploits
			if ( totalTimePlayed > gameLength )
			{
				totalTimePlayed = gameLength;
			}
			
			spm = player rank::getSPM();

			isWinner = false;
			for ( pIdx = 0; pIdx < min( level.placement["all"][0].size, 3 ); pIdx++ )
			{
				if ( level.placement["all"][pIdx] != player )
					continue;
				isWinner = true;				
			}
			
			if ( isWinner )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player globallogic_score::giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (totalTimePlayed / gameLength) );
				player globallogic_score::giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
			player.pers["totalMatchBonus"] += player.matchBonus;
		}
	}
}
*/

function timescalekc()
{
	if(!isDefined(self.kctime))
	{
		self iPrintln("killcam timescale: ^6on");
		self.kctime = true;
	}
	else
	{
		self iPrintln("killcam timescale: ^5off");
		self.kctime = undefined;
        level waittill("game_ended");
		self notify("stoptskc");
        setdvar("timescale", 1);    
	}
}


function cc33bind1()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.ccbind))
	{
		self iPrintLn("^5save canswap bind^7 binded to [{+Actionslot 1}]");
        self iprintlnbold("select a ^6gun^7 and ^6switch weapons^7 for canswap");
		self.ccbind = true;
		while(isDefined(self.ccbind))
		{
			if(self actionslotonebuttonpressed())
			{
				self thread changeclassthreecanbind();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.ccbind)) 
	{ 
		self iPrintLn("^5save canswap bind^7 bind: ^5off");
		self.ccbind = undefined; 
	} 
}

function cc33bind2()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.ccbind))
	{
		self iPrintLn("^5save canswap bind^7 binded to [{+Actionslot 2}]");
        self iprintlnbold("select a ^6gun^7 and ^6switch weapons^7 for canswap");
		self.ccbind = true;
		while(isDefined(self.ccbind))
		{
			if(self actionslottwobuttonpressed())
			{
				self thread changeclassthreecanbind();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.ccbind)) 
	{ 
		self iPrintLn("^5save canswap bind^7 bind: ^5off");
		self.ccbind = undefined; 
	} 
}

function cc33bind3()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.ccbind))
	{
		self iPrintLn("^5save canswap bind^7 binded to [{+Actionslot 3}]");
        self iprintlnbold("select a ^6gun^7 and ^6switch weapons^7 for canswap");
		self.ccbind = true;
		while(isDefined(self.ccbind))
		{
			if(self actionslotthreebuttonpressed())
			{
				self thread changeclassthreecanbind();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.ccbind)) 
	{ 
		self iPrintLn("^5save canswap bind^7 bind: ^5off");
		self.ccbind = undefined; 
	} 
}

function cc33bind4()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.ccbind))
	{
		self iPrintLn("^5save canswap bind^7 binded to [{+Actionslot 4}]");
        self iprintlnbold("select a ^6gun^7 and ^6switch weapons^7 for canswap");
		self.ccbind = true;
		while(isDefined(self.ccbind))
		{
			if(self actionslotfourbuttonpressed())
			{
				self thread changeclassthreecanbind();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.ccbind)) 
	{ 
		self iPrintLn("^5save canswap bind^7 bind: ^5off");
		self.ccbind = undefined; 
	} 
}


function changeclassthreecanbind()
{
    self thread threechangeclassbind();
    wait 0.010;
    self.nova = self getCurrentweapon();
			/*
		            self seteverhadweaponall( 1 );
					0, self.camo, 1, 0, 0, 0)
					*/
    ammoW     = self getWeaponAmmoStock( self.nova );
    ammoCW    = self getWeaponAmmoClip( self.nova );
    self TakeWeapon(self.nova);
    self GiveWeapon(self.nova);
    self setweaponammostock( self.nova, ammoW );
    self setweaponammoclip( self.nova, ammoCW);
}

function threechangeclassbind()
{
    if(!self.cclass)
    {
        self.cclass = 1;
	    self notify( "menuresponse", "change_class", "CLASS_CUSTOM1"); 
    }
    else
    {
        if( self.cclass == 1 )
        {
            self.cclass = 2;
	    self notify( "menuresponse", "change_class", "CLASS_CUSTOM2"); 
        }
        else
        {
            if( self.cclass == 2 )
            {
                self.cclass = 3;
	    self notify( "menuresponse", "change_class", "CLASS_CUSTOM3"); 
            }
            else
            {
                if( self.cclass == 3 )
                {
                    self.cclass = 1;
	    self notify( "menuresponse", "change_class", "CLASS_CUSTOM1"); 
                }
            }
        }
    }

}


function monitor_class()
{
    self endon("disconnect");
    level endon("game_ended");

    for(;;)
    {
        self waittill("changed_class");

        self loadout::setclass(self.curClass);
        self loadout::giveloadout(self.team, self.curClass); // self.curclass has leftovers in the script dump, seems self.curClass is the new var

        WAIT_SERVER_FRAME; // probably not needed but just in case
    }
}
/*
		primary = self GetLoadoutWeapon( classIndex, "primary" );
		secondary = self GetLoadoutWeapon( classIndex, "secondary" );
        */



function inacbind(actionslot)
{
    if (!isdefined(self.inacbind)) self.inacbind = false;
    if (self.inacbind)
    {
        self notify("stopnac");
        self iprintln( "^7infinite nac bind: ^5off" );
        self.inacbind = false;
	    primary = self GetLoadoutWeapon( self.CurClass, "primary" );
	    secondary = self GetLoadoutWeapon( self.CurClass, "secondary" );
    }
    else if (!self.inacbind)
    {
        self iprintln( "^7infinite nac binded to ^5[{+actionslot " + actionslot + "}]" );
        self thread toggleinacbind();
        self.inacbind = true;
    }
}

function toggleinacbind(actionslot)
{
    self endon("disconnect");
    self endon("stopnac");
    level endon("game_ended");
    for(;;)
    {
            if (actionslot == "1" && self actionSlotOneButtonPressed())
            {
                self thread doinac();
            }
            else if (actionslot == "2" && self actionSlotTwoButtonPressed())
            {
                self thread doinac();
            }
            else if (actionslot == "3" && self actionSlotThreeButtonPressed())
            {
                self thread doinac();
            }
            else if (actionslot == "4" && self actionSlotFourButtonPressed())
            {
                self thread doinac();
        
            }
        wait 0.05;
        }
}

function doinac()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    
	primary = self GetLoadoutWeapon( self.CurClass, "primary" );
	secondary = self GetLoadoutWeapon( self.CurClass, "secondary" );

    if (self GetCurrentWeapon() == primary && !self.menu.open)
    {
        self.ammo3 = self getweaponammoclip(secondary);
        self.ammo4 = self getweaponammostock(secondary);
        self takeweapon(secondary);
        wait 0.10;
        self giveweapon(secondary);
        self setweaponammoclip(secondary, self.ammo3);
        self setweaponammostock(secondary, self.ammo4);
        wait 0.05;
        self setweaponammoclip(secondary, self.ammo3);
        self setweaponammostock(secondary, self.ammo4);
    }
    else if( self GetCurrentWeapon() == secondary && !self.menu.open )
    {
        self.ammo1 = self getweaponammoclip(primary);
        self.ammo2 = self getweaponammostock(primary);
        self takeweapon(primary);
        wait 0.10;
        self giveweapon(primary);
        self setweaponammoclip(primary, self.ammo1);
        self setweaponammostock(primary, self.ammo2);
        wait 0.05;
        self setweaponammoclip(primary, self.ammo1);
        self setweaponammostock(primary, self.ammo2);
    }

}

		
 


function nacbind(actionslot)
{
    if (!isdefined(self.nacbind)) self.nacbind = false;
    if (self.nacbind)
    {
        self notify("stopnac");
        self iprintln( "^7nac bind: ^5off" );
        self.nacshit = 0;
        self.nacswap = "no";
        self.wep = "none";
        self.wep2 = "none";
        self.nacbind = false;
    }
    else if (!self.nacbind)
    {
        self iprintln( "^7nac bind binded to ^5[{+actionslot " + actionslot + "}]" );
        wait 0.25;
        self iprintln( "still working on a ^6camo ^7fix");
        self thread togglenacbind(actionslot);
        self.nacbind = true;
    }
}

function togglenacbind(actionslot)
{
    self endon("disconnect");
    self endon("stopnac");
    level endon("game_ended");
    for(;;)
    {
        if (self getstance() != "prone")
        {
            if (actionslot == "1" && self actionSlotOneButtonPressed())
            {
                self thread checknacwep();
            }
            else if (actionslot == "2" && self actionSlotTwoButtonPressed())
            {
                self thread checknacwep();
            }
            else if (actionslot == "3" && self actionSlotThreeButtonPressed())
            {
                self thread checknacwep();
            }
            else if (actionslot == "4" && self actionSlotFourButtonPressed())
            {
                self thread checknacwep();
            }
        }
        else
        {
            if (self getstance() == "prone" && self changeseatbuttonpressed() && self adsbuttonpressed())
            {
                if (self.nacswap == "yes")
                {
                    self iprintln( "^7selected weapons: ^5reset" );
                    self.nacswap = "no";
                    self.wep = "none";
                    self.wep2 = "none";
                }
            }
        }
        wait 0.05;
    }
}

function equipmentinstant(currentoffhand)
{
    self endon ("stopequipfill");
    self iprintLn ("^7equipment refill time: ^6instant");
    for(;;)
    {
        self.nova = self getCurrentweapon();
        ammoW = self getWeaponAmmoStock( self.nova );
        currentoffhand = self GetCurrentOffhand();
        self thread refillammo();
        if ( currentoffhand != "none" )
        {
            self setWeaponAmmoClip( currentoffhand, 9999 );
            self GiveMaxAmmo( currentoffhand );
            self setweaponammostock( self.nova, ammoW );
        }
        wait 0.05;
    }
}


function checknacwep()
{
    if( self.nacswap == "no" )
    {
        if( self.wep == "none" )
        {
            self.wep = self GetCurrentWeapon();
            self iprintln( "first weapon: ^5" + self.wep.name);
        }
        else
        {
            if( self GetCurrentWeapon() != "none" && self GetCurrentWeapon() != self.wep && self.wep != "none" )
            {
                self.wep2 = self GetCurrentWeapon();
                self iprintln( "second weapon: ^5" + self.wep2.name);
                self.nacswap = "yes";
                wait 0.5;
                self iprintln( "press [{+speed_throw}] ^5+^7 [{+switchseat}] ^5&^7 prone to ^5reset ^7weapons." );
            }
        }
    }
    else
    {
        
        donac();
    }

}

function donac()
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    if (self GetCurrentWeapon() == self.wep2 && !self.menu.open)
    {
        self.ammo3 = self getweaponammoclip(self GetCurrentWeapon());
        self.ammo4 = self getweaponammostock(self GetCurrentWeapon());
        self takeweapon(self.wep2);
        wait 0.10;
        self giveweapon(self.wep2);
        self setweaponammoclip(self.wep2, self.ammo3);
        self setweaponammostock(self.wep2, self.ammo4);
        wait 0.05;
        self setweaponammoclip(self.wep2, self.ammo3);
        self setweaponammostock(self.wep2, self.ammo4);
    }
    else if( self GetCurrentWeapon() == self.wep && !self.menu.open )
    {
        self.ammo1 = self getweaponammoclip(self GetCurrentWeapon());
        self.ammo2 = self getweaponammostock(self GetCurrentWeapon());
        self takeweapon(self.wep);
        wait 0.10;
        self giveweapon(self.wep);
        self setweaponammoclip(self.wep, self.ammo1);
        self setweaponammostock(self.wep, self.ammo2);
        wait 0.05;
        self setweaponammoclip(self.wep, self.ammo1);
        self setweaponammostock(self.wep, self.ammo2);
    }

}



function time75()
{
	if(!isDefined(self.time75))
	{
		self.time75 = true;
		self iPrintln("timescale set to ^60.75^7");
        setdvar("timescale", 0.75);    
	}
	else
	{
		self.time75 = undefined;
		self iPrintln("timescale set to ^6normal^7");
		self notify("stoptimescale75");
        setdvar("timescale", 1);    
	}
}

function time50()
{
	if(!isDefined(self.time50))
	{
		self.time50 = true;
		self iPrintln("timescale set to ^60.50^7");
        setdvar("timescale", 0.50);    
	}
	else
	{
		self.time50 = undefined;
		self iPrintln("timescale set to ^6normal^7");
		self notify("stoptimescale50");
        setdvar("timescale", 1);    
	}
}


function time10()
{
	if(!isDefined(self.time10))
	{
		self.time10 = true;
		self iPrintln("timescale set to ^60.10^7");
        setdvar("timescale", 0.10);    
	}
	else
	{
		self.time10 = undefined;
		self iPrintln("timescale set to ^6normal^7");
		self notify("stoptimescale10");
        setdvar("timescale", 1);    
	}
}


function time25()
{
	if(!isDefined(self.time25))
	{
		self.time25 = true;
		self iPrintln("timescale set to ^60.25^7");
        setdvar("timescale", 0.25);    
	}
	else
	{
		self.time25 = undefined;
		self iPrintln("timescale set to ^6normal^7");
		self notify("stoptimescale25");
        setdvar("timescale", 1);    
	}
}


function botcall()
{
    foreach (bot in level.players)
    {
        
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"] && isDefined(self.frozenbots))
        {
            
            bot globallogic_score::_setplayermomentum(bot, 9999);

            wait 0.05;
            bot freezecontrols(false);
            wait 0.002;
            bot freezecontrols(true);
        } 
        else if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"] && !isDefined(self.frozenbots))
        {
            bot globallogic_score::_setplayermomentum(bot, 9999);

            wait 0.05;
            bot freezecontrols(false);
            wait 0.002;
            bot freezecontrols(true);
        }
    self iprintlnbold("bots now calling ^6random^7 streaks");   
    }


}

function streaks(){
	self globallogic_score::_setplayermomentum(self, 9999);

    if (!self pickup_items::has_active_gadget())
    {

    self gadgetpowerset(0,100);
    }
}


function mw2()
{
        level waittill("game_ended");
        self enableInvulnerability();
        self freezecontrols(false);
        wait 1;
        self freezecontrols(true);

        
}


function fastlast()

{
	self.pointstowin = 29; // change all the 1's to your kill limit... if it was 10, do 9, and edit the score. self.score goes by 200's
	self.pers["pointstowin"] = 29;
	self.score = 200;
	self.pers["score"] = 100;
	self.kills = 29;
	self.deaths = 0;
	self.headshots = 0;
	self.pers["kills"] = 29;
	self.pers["deaths"] = 0;
	self.pers["headshots"] = 0;

}

function func_ufomode()
{
    if(!isDefined(self.gamevars["ufomode"]))
    {
        self thread func_activeUfo();
        self.gamevars["ufomode"] = true;
        self iPrintln("ufo ^6enabled");
        self iPrintln("[{+frag}] to ^6fly");
    }
    else
    {
        self notify("func_ufomode_stop");
        self.gamevars["ufomode"] = undefined;
        self iPrintln("ufo ^6disabled");
    }
}


function func_activeUfo()
{
    self endon("func_ufomode_stop");
    self.Fly = 0;
    UFO = spawn("script_model",self.origin);
    for(;;)
    {
        if(self FragButtonPressed())
        {
            
            self playerLinkTo(UFO);
            self.Fly = 1;
			self disableweapons();
			foreach(w in self.owp)
			self takeweapon(w);
        }
        else
        {
            self unlink();
            self.Fly = 0;
			self enableweapons();
			foreach(w in self.owp)
			self giveweapon(w);
        }
        if(self.Fly == 1)
        {
            Fly = self.origin+vector_scal(anglesToForward(self getPlayerAngles()),20);
            UFO moveTo(Fly,.01);
        }
        wait .001;
    }
}

function vector_scal(vec, scale)
{
    vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
    return vec;
}

function friendly()
{
    if (self.team == "allies")
    bot::add_bots(1, "allies");
    else 
    bot::add_bots(1, "axis");

    self IPrintLn("^2friendly^7 bot ^6spawned");
    wait 0.05;
    self thread changebotver();
    
}

function enemies()
{
    if (self.team == "axis")
    bot::add_bots(1, "allies");
    else 
    bot::add_bots(1, "axis");

    self IPrintLn("^1enemy^7 bot ^6spawned");
    wait 0.05;
    self thread changebotver();
    
}


function removeSkyBarrier()
{
    entArray = GetEntArray();
    for (index = 0; index < entArray.size; index++)
    {
        if(isSubStr(entArray[index].classname, "trigger_hurt") && entArray[index].origin[2] > 180)
            entArray[index].origin = (0, 0, 9999999);
    }
}

function tptothem(player)
{
    self setorigin(player.origin);
}


function updatePlayersMenu()
{
    self endon("disconnect");
  
    self.menu.menucount["PlayersMenu"] = 0;
  
    for (i = 0; i < 18; i++)
    {
        player = level.players[i];
        playerName = getPlayerName(player);
        playersizefixed = level.players.size - 1;
      
        if(self.menu.curs["PlayersMenu"] > playersizefixed)
        {
            self.menu.scrollerpos["PlayersMenu"] = playersizefixed;
            self.menu.curs["PlayersMenu"] = playersizefixed;
        }
      
        add_option("PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + playerName, &submenu, "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
            add_menu("pOpt " + i, "PlayersMenu", "[" + verificationToColor(player.status) + "^7] " + playerName);
                add_option("pOpt " + i, "teleport options", &submenu, "pOpt " + i + "_3", "[" + verificationToColor(player.status) + "^7] " + playerName);
                add_option("pOpt " + i, "respawn player", &respawnThePlayer, player);
                add_option("pOpt " + i, "switch teams", &switchTeams, player);
                    add_menu("pOpt " + i + "_3", "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);

                        add_option("pOpt " + i + "_3", "teleport to crosshair", &tpcrosshairp, player);
                        add_option("pOpt " + i + "_3", "teleport to me", &tptome, player);
                        add_option("pOpt " + i + "_3", "teleport to them", &tptothem, player);
                        /*
                        add_option("pOpt " + i + "_3", "^6Verify", &changeVerificationMenu, player, "Verified");
                        add_option("pOpt " + i + "_3", "^4VIP", &changeVerificationMenu, player, "VIP");
                        add_option("pOpt " + i + "_3", "^6Admin", &changeVerificationMenu, player, "Admin");
                        add_option("pOpt " + i + "_3", "^6Co-Host", &changeVerificationMenu, player, "Co-Host");
                      */
                      /*
        if(!player isHost())
        {
                add_option("pOpt " + i, "Options", &submenu, "pOpt " + i + "_2", "[" + verificationToColor(player.status) + "^7] " + playerName);
                    add_menu("pOpt " + i + "_2", "pOpt " + i, "[" + verificationToColor(player.status) + "^7] " + playerName);
                        add_option("pOpt " + i + "_2", "Kill Player", &killPlayer, player);
                        */
        }
}

function tpcrosshairp(player)
{

    player setorigin(bullettrace(self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )[ "position"] );

    }  

function tpbotstocrosshair()
{
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            
            bot setorigin(bullettrace(self gettagorigin( "j_head" ), self gettagorigin( "j_head" ) + anglestoforward( self getplayerangles() ) * 1000000, 0, self )[ "position"] );
            bot.pers["vars"]["bo"] = bot.origin;
            bot.pers["vars"]["ba"] = bot.angles;
            bot freezecontrols(true);
        }
    }
    self iprintln("bots teleported to ^3crosshair^7");
}





function dohitmarkerok()
{
    self playlocalsound("mpl_hit_alert");
    self.hud_damagefeedback setshader("damage_feedback", 24, 48);
    self.hud_damagefeedback.alpha = 1;
    self.hud_damagefeedback fadeovertime(1);
    self.hud_damagefeedback.alpha = 0;
}


function aimboobs()
{
    if (!isdefined(self.aimbot)) self.aimbot = false;
    if (!self.aimbot)
    {
        self thread aimbot();
        self.hitaimbotweapon = self getcurrentweapon();
        self iprintln("tag eb: ^2on");
        self iprintln("weapon: ^2" + self.hitaimbotweapon);
        
    }
    else
    {
        self notify( "aimbot" );
        self iprintln("tag eb: ^1off");
    }
    self.aimbot = !self.aimbot;
}

function aimbot()
{
    self endon( "disconnect" );
    self endon( "aimbot" );
    level endon("game_ended");
    self waittill( "weapon_fired" );
	for(i=0;i<level.players.size;i++)
	{
                    if (isdefined(self.hitaimbotweapon) && self getcurrentweapon() == self.hitaimbotweapon)
                    {
                        // zombie dodamage( zombie.health + 0, ( 0, 0, 0 ) );
                        // zombie thread [[ level.callbackactorkilled ]]( self, self, (zombie.health + 100), "MOD_RIFLE_BULLET", self getcurrentweapon(), ( 0, 0, 0 ), ( 0, 0, 0 ), 0 );
                       // self [[ level.callbackactorkilled ]]( inflictor, attacker, damage, meansofdeath, weapon, vdir, shitloc, psoffsettime );
                       self thread dohitmarkerok();
                       level.players[i] thread [[level.callbackPlayerDamage]] ( self, self, 1, 8, "MOD_RIFLE_BULLET", self GetCurrentWeapon(), ( 0, 0, 0 ), ( 0, 0, 0 ), "body", 0, 0 );
                    }
                }
}
/*
ChangeMapFixed(mapR)
{
    SetDvar("ls_mapname", mapR);
    SetDvar("mapname", mapR);
    SetDvar("party_mapname", mapR);
    SetDvar("ui_mapname", mapR);
    SetDvar("ui_currentMap", mapR);
    SetDvar("ui_mapname", mapR);
    SetDvar("ui_preview_map", mapR);
    SetDvar("ui_showmap", mapR);
    Map(mapR);
}
*/

function MakeAllBotsLookAtYou()
{
    foreach (bot in level.players)
    { 
        if(isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            bot setplayerangles(VectorToAngles((self.origin + (0,0,30)) - (bot getTagOrigin("j_head"))));

        }
    }
        self iprintln("all bots are now ^5looking at you");
}

/*
function MakeAllBotsCrouch()
{
    if(!isDefined(self.crouchedbots))
    {
    foreach (bot in level.players)
    { 
            if(isDefined(bot.pers["isBot"])&& bot.pers["isBot"])
            {
            bot setstance( "crouch" );
            wait 0.5;
            bot setstance( "crouch" );
            wait 0.5;
            }
            
        }
            self.crouchedbots = true;
            self iprintln("all bots are now ^5crouched");
    }
    else
    {
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            bot setstance( "stand" );
            wait 0.5;
            bot setstance( "stand" );
            wait 0.5;
            }
        }
        self.crouchedbots = undefined;
        self iprintln("all bots are now ^6standing");
    }
}

*/
/*
function toggleBomb()
{
    if(!isDefined(self.bombEnabled))
    {
        setDvar("bombEnabled", "1");
        self.bombEnabled = true;
        self iprintlnbold("bomb ^6enabled");
    }
    else 
    {
        setDvar("bombEnabled", "0");
        self.bombEnabled = false;
        self iprintlnbold("bomb ^5disabled");
    }
}
*/
/*
function MakeAllBotsProne()
{
    if(!isDefined(self.crouchedbots))
    {
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
                bot setstance("prone");
                self.crouchedbots = true;
                self iprintln("all bots are now ^5prone");
            }
        }
    }
    else
    {
    if(isDefined(self.crouchedbots))
    {
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            bot setstance( "stand" );
            wait 0.5;
            bot setstance( "stand" );
            wait 0.5;
                self.crouchedbots = undefined;
                self iprintln("all bots are now ^6standing");
            }
    }
        }
    }
}

function MakeAllBotsStand()
{
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            bot setstance( "stand" );
            wait 0.5;
            bot setstance( "stand" );
            wait 0.5;
        }
    }
	self iprintln("all bots are now ^6standing");
}
*/
function MoveNorthpixel()
{
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            NewOrigin = bot.origin + (0,1,0);
            bot setorigin(NewOrigin);
            self iprintln("bot moved to ^6" + NewOrigin);
        }
    }
}

function MoveSouthpixel()
{
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            NewOrigin = bot.origin + (0,-1,0);
            bot setorigin(NewOrigin);
            self iprintln("bot moved to ^6" + NewOrigin);
        }
    }
}

function MoveEastpixel()
{
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            NewOrigin = bot.origin + (1,0,0);
            bot setorigin(NewOrigin);
            self iprintln("bot moved to ^6" + NewOrigin);
        }
    }
}

function MoveWestpixel()
{
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            NewOrigin = bot.origin + (-1,0,0);
            bot setorigin(NewOrigin);
            self iprintln("bot moved to ^6" + NewOrigin);
        }
    }
}

function GetBotLocation()
{
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            self iPrintLn("^7bot loc: ^6" + bot getOrigin());
        }
    }
}


function freezeAllBots()
{
    if(!isDefined(self.frozenbots))
    {
    foreach (bot in level.players)
    {

        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
                bot freezeControls(true);
            }
            self.frozenbots = true;
            wait .025;
        }
        self iprintln("all bots ^6frozen");
    }
    else
    {

    foreach (bot in level.players)
    {

        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"] && isDefined(self.frozenbots))
        {
                bot freezeControls(false);
            }
        }
        self.frozenbots = undefined;
        self iprintln("all bots ^5unfrozen");
    }
}


function tptome(player)
{

    player setorigin(self.origin);
    }

function add_menu(Menu, prevmenu, menutitle)
{
    self.menu.getmenu[Menu] = Menu;
    self.menu.scrollerpos[Menu] = 0;
    self.menu.curs[Menu] = 0;
    self.menu.menucount[Menu] = 0;
    self.menu.subtitle[Menu] = menutitle;
    self.menu.previousmenu[Menu] = prevmenu;
}

function add_option(Menu, Text, Func, arg1, arg2)
{
    Menu = self.menu.getmenu[Menu];
    Num = self.menu.menucount[Menu];
    self.menu.menuopt[Menu][Num] = Text;
    self.menu.menufunc[Menu][Num] = Func;
    self.menu.menuinput[Menu][Num] = arg1;
    self.menu.menuinput1[Menu][Num] = arg2;
    self.menu.menucount[Menu] += 1;
}

function _openMenu()
{
    self.recreateOptions = true;
    self enableInvulnerability();
    self thread StoreText(self.CurMenu, self.CurTitle);
  
    self.violet["title"].alpha = 0;
    self.violet["root"].alpha = 0.85;
    self.violet["value"].alpha = 1;
    self.violet["background"].alpha = 0.6;
    self.violet["scrollbar"].alpha = 0.25;
    self.violet["bartop"].alpha = 0.28;
    self.violet["value2"].alpha = 1;
    self.violet["slash"].alpha = 0.75;
  
    if(!self.menu.menuopt[self.CurMenu].size <= 5)
    {
        self.violet["arrowtop"].alpha = 0;
        self.violet["arrowbottom"].alpha = 0;
    }
  
    self updateScrollbar();
    self.menu.open = true;
    self.recreateOptions = false;
    self setclientuivisibilityflag("hud_visible", 0);
}

function _closeMenu()
{
  
    if(!self.godmode)
        self disableInvulnerability();

    self setclientuivisibilityflag("hud_visible", 1);
    if(!self.hudon)
    self setclientuivisibilityflag("hud_visible", 0);
    if(isDefined(self.violet["options"]))
    {
        for(i = 0; i < self.violet["options"].size; i++)
            self.violet["options"][i] destroy();
    }
  
    self.violet["title"].alpha = 0;
    self.violet["slash"].alpha = 0;
    self.violet["value"].alpha = 0;
    self.violet["value2"].alpha = 0;
    self.violet["arrowtop"].alpha = 0;
    self.violet["arrowbottom"].alpha = 0;
    self.violet["bartop"].alpha = 0;
    self.violet["background"].alpha = 0;
    self.violet["root"].alpha = 0;
    self.violet["scrollbar"].alpha = 0;
  
    self.menu.open = false;

}

function giveMenu()
{
        if(!self.MenuInit)
        {
            self.MenuInit = true;
            self thread MenuInit();
        }
    }

function destroyMenu()
{
    self.MenuInit = false;
    self notify("destroyMenu");
  
  
    //do not remove
    if(!self.InfiniteHealth)
        self disableInvulnerability();
  
    if(isDefined(self.violet["options"]))
    {
        for(i = 0; i < self.violet["options"].size; i++)
            self.violet["options"][i] destroy();
    }

    self.menu.open = false;
  
    wait 0.01;
    self.violet["background"] destroy();
    self.violet["scrollbar"] destroy();
    self.violet["bartop"] destroy();
    self.violet["arrowtop"] destroy();
    self.violet["arrowbottom"] destroy();
    self.violet["title"] destroy();
    self.violet["slash"] destroy();
    self.violet["value2"] destroy();
    self.violet["value"] destroy();
    self.violet["root"] destroy();
}

function submenu(input, title)
{
    if (input == "violet")
        self thread StoreText(input, "violet");
    else
        if (input == "PlayersMenu")
        {
            self updatePlayersMenu();
            self thread StoreText(input, "player settings");
        }
        else
            self thread StoreText(input, title);
          
    self.CurMenu = input;
    self.CurTitle = title;
  
    self.menu.scrollerpos[self.CurMenu] = self.menu.curs[self.CurMenu];
    self.menu.curs[input] = self.menu.scrollerpos[input];
  
    self updateScrollbar();
}

//HUD Elements

function StoreHuds()
{
    // function createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha)
    self.violet["background"] = CreateRectangle("RIGHT", "TOPLEFT", 310, undefined, undefined, undefined, (0,0,0), undefined, 3, 0);
    self.violet["scrollbar"] = CreateRectangle("RIGHT", "TOPLEFT", 310, 103, 191, 18, (0.522,0.322,0.451), "white", 8, 0);
    self.violet["bartop"] = CreateRectangle("RIGHT", "TOPLEFT", 310, 84, 191, 20, (0,0,0), "light_corona", 7, 0);
    self.violet["arrowtop"] = CreateRectangle("RIGHT", "TOPLEFT", 218, 197, 7, 7, (1,1,1), "ui_scrollbar_arrow_up_a", 9, 0);
    self.violet["arrowbottom"] = CreateRectangle("RIGHT", "TOPLEFT", 218, 205, 7, 7, (1,1,1), "ui_scrollbar_arrow_dwn_a", 9, 0);
    self.violet["title"] = drawText("violet", "bigfixed", 1.25, "LEFT", "TOPLEFT", 161, 48, (1,1,1), 0, 9);
    self.violet["slash"] = drawText("|", "objective", 1.1, "RIGHT", "TOPLEFT", 290, 83, (1,1,1), 0, 9);
    self.violet["root"] = drawText("", "objective", 1.1, "LEFT", "TOPLEFT", 126, 83, (0.522,0.322,0.451), 0, 9);
  
    self.violet["value"] = drawValue("", "objective", 1.1, "RIGHT", "TOPLEFT", 302, 83, (0.831,0.784,0.812), 0, 9);
    self.violet["value2"] = drawValue("", "objective", 1.1, "RIGHT", "TOPLEFT", 282, 83, (0.522,0.322,0.451), 0, 9);
}

function createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha)
{
      hud = newClientHudElem(self);
      hud.elemType = "bar";
      hud.children = [];
      hud.sort = sort;
      hud.color = color;
      hud.alpha = alpha;
      hud.hideWhenInMenu = true;
      hud.foreground = true;
      hud hud::setParent(level.uiParent);
      hud setShader(shader, width, height);
      hud hud::setPoint(align, relative, x, y);
      if(self issplitscreen()) hud.x += 100;//make sure to change this when moving huds
      return hud;
}

/*
    self.violet["slash"].alpha = 0; // option seperator number
    self.violet["value"].alpha = 0; / list amount number
    self.violet["value2"].alpha = 0; // option number
    self.violet["root"].alpha = 0; // text color
    self.violet["scrollbar"].alpha = 0; 
    */

function flickershaders()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        if (self.menu.open)
        {
            waittime = 1;
            self.violet FadeOverTime(waittime);
            self.violet["root"] FadeOverTime(waittime);
            self.violet["value2"] FadeOverTime(waittime);
            self.violet["root"].color = (0.522,0.322,0.451);
            self.violet["value2"].color = (0.522,0.322,0.451);

            wait waittime;

            self.violet FadeOverTime(waittime);
            self.violet["root"] FadeOverTime(waittime);
            self.violet["value2"] FadeOverTime(waittime);
            self.violet["root"].color = (1, 1, 1);
            self.violet["value2"].color = (1, 1, 1);

            wait waittime;
            self.violet FadeOverTime(waittime);
            self.violet["root"] FadeOverTime(waittime);
            self.violet["value2"] FadeOverTime(waittime);
            self.violet["root"].color = (0.831,0.784,0.812);      
            self.violet["value2"].color = (0.831,0.784,0.812);   

            
        }
        wait 0.05;
    }
}

function backgroundsize(height, yValue)
{
    self.violet["background"] setShader("white", 191, height);
    self.violet["background"].y = 142 - yValue;
}

function StoreText(menu, title)
{
    if(self.menu.menuopt[menu].size <= 5)
    {
        self.violet["arrowtop"].alpha = 0;
        self.violet["arrowbottom"].alpha = 0;
      
        height = (self.menu.menuopt[menu].size*20);
      
        if(self.menu.menuopt[menu].size == 5) self backgroundsize(height + 18, 9);
        else if(self.menu.menuopt[menu].size == 4) self backgroundsize(height + 18, 19);
        else if(self.menu.menuopt[menu].size == 3) self backgroundsize(height + 18, 29);
        else if(self.menu.menuopt[menu].size == 2) self backgroundsize(height + 18, 39);
        else if(self.menu.menuopt[menu].size == 1) self backgroundsize(height + 18, 49);
    }
    else
    {
        self.violet["arrowtop"].alpha = 0;
        self.violet["arrowbottom"].alpha = 0;
        self.violet["background"] setShader("white", 191, 136);
        self.violet["background"].y = 142;
    }
  
    self.violet["root"] setSafeText(title + " - ^7private");
    self.violet["value"] setValue(self.menu.menuopt[menu].size);
  
    if(self.recreateOptions)
        for(i = 0; i < 5; i++)
        self.violet["options"][i] = drawText("", "objective", 1.1, "LEFT", "TOPLEFT", 126, 102 + (i*20), (1,1,1), 1, 9);
    else
        for(i = 0; i < 5; i++)
        self.violet["options"][i] setSafeText(self.menu.menuopt[menu][i]);
}

function updateScrollbar()
{
    if(self.menu.curs[self.CurMenu]<0)
        self.menu.curs[self.CurMenu] = self.menu.menuopt[self.CurMenu].size-1;
      
    if(self.menu.curs[self.CurMenu]>self.menu.menuopt[self.CurMenu].size-1)
        self.menu.curs[self.CurMenu] = 0;
      
    if(!isDefined(self.menu.menuopt[self.CurMenu][self.menu.curs[self.CurMenu]-2])||self.menu.menuopt[self.CurMenu].size<=5)
    {
        for(i = 0; i < 5; i++)
        {
            if(isDefined(self.menu.menuopt[self.CurMenu][i]))
                self.violet["options"][i] setSafeText(self.menu.menuopt[self.CurMenu][i]);
            //else
            //    self.violet["options"][i] setSafeText("");
                  
            if(self.menu.curs[self.CurMenu] == i)
            {
                self.violet["value2"] setValue(i+1);
                self.violet["options"][i].color = (1,1,1);
            }
            else
                   self.violet["options"][i].color = (1,1,1);
        }
        self.violet["scrollbar"].y = 103 + (20*self.menu.curs[self.CurMenu]);
    }
    else
    {
        if(isDefined(self.menu.menuopt[self.CurMenu][self.menu.curs[self.CurMenu]+2]))
        {
            xePixTvx = 0;
            for(i=self.menu.curs[self.CurMenu]-2;i<self.menu.curs[self.CurMenu]+3;i++)
            {
                if(isDefined(self.menu.menuopt[self.CurMenu][i]))
                    self.violet["options"][xePixTvx] setSafeText(self.menu.menuopt[self.CurMenu][i]);
               // else
              //     self.violet["options"][xePixTvx] setSafeText("");
                  
                if(self.menu.curs[self.CurMenu]==i)
                {
                    self.violet["value2"] setValue(i+1);
                    self.violet["options"][xePixTvx].color = (1,1,1);
                  }
                  else
                    self.violet["options"][i].color = (1,1,1);
                    
                xePixTvx ++;
            }          
            self.violet["scrollbar"].y = 103 + (20*2);
        }
        else
        {
            for(i = 0; i < 5; i++)
            {
                self.violet["options"][i] setSafeText(self.menu.menuopt[self.CurMenu][self.menu.menuopt[self.CurMenu].size+(i-5)]);
              
                if(self.menu.curs[self.CurMenu]==self.menu.menuopt[self.CurMenu].size+(i-5))
                {
                    self.violet["value2"] setValue((self.menu.menuopt[self.CurMenu].size+(i-5))+1);
                    self.violet["options"][i].color = (1,1,1);
                }
                else
                    self.violet["options"][i].color = (1,1,1);
            }
            self.violet["scrollbar"].y = 103 + (20*((self.menu.curs[self.CurMenu]-self.menu.menuopt[self.CurMenu].size)+5));
        }
    }
}

//HUD Utilites

function drawText(text, font, fontScale, align, relative, x, y, color, alpha, sort)
{
      hud = hud::createFontString(font, fontScale);
      hud hud::setPoint(align, relative, x, y);
      hud.color = color;
      hud.alpha = alpha;
      hud.hideWhenInMenu = true;
      hud.sort = sort;
      hud.foreground = true;
      if(self issplitscreen()) hud.x += 100;
      hud setSafeText(text);
      return hud;
}

function drawValue(value, font, fontScale, align, relative, x, y, color, alpha, sort)
{
    hud = hud::createFontString(font,fontScale);
    level.result += 1;
    level notify("textset");
    hud setValue(value);
    hud.color = color;
    hud.sort = sort;
    hud.alpha = alpha;
    hud.foreground = true;
    hud.hideWhenInMenu = true;
    hud hud::setPoint(align, relative, x, y);
    return hud;
}


function setSafeText(text)
{
    level.result += 1;
    level notify("textset");
    self setText(text);
}

//xTUL Overflow Fix

 




function recreateText()
{
    self submenu(self.CurMenu, self.CurTitle);
  
    self.violet["title"] setSafeText("violet");
    self.violet["slash"] setSafeText("|");
}

// d
function overflowfix()
{
    level endon("game_ended");
    level endon("host_migration_begin");
  
    level.test = hud::createServerFontString("default", 1);
    level.test setText("xTUL");
    level.test.alpha = 0;
  
    if(GetDvarString("g_gametype") == "sd")
        A = 45;
    else
        A = 55;
      
    for(;;)
    {
        level waittill("textset");

        if(level.result >= A)
        {
            //level.test ClearAllTextAfterHudElem();
            level.result = 0;

            foreach(player in level.players)
                if(player.menu.open && player isVerified())
                    player recreateText();
        }
    }
}

//Verification System

function verificationToColor(status)
{
    if (status == "Host")
        return "^6appa";
    if (status == "Verified")
        return "^5user";
    if (status == "Bot")
        return "^3npc";
}

function changeVerificationMenu(player, verlevel)
{
    if (player.status != verlevel && !player isHost())
    {
        if(player isVerified())
        player thread destroyMenu();
        wait 0.03;
        player.status = verlevel;
        wait 0.01;
      
        if(player.status == "Unverified")
        {
            player iPrintln("your access level has been set to none");
            self iprintln("access level has been set to none");
        }
        if(player isVerified())
        {
            player giveMenu();
          
            self iprintln("set access level for " + getPlayerName(player) + " to " + verificationToColor(verlevel));
            player iPrintln("your access level has been set to " + verificationToColor(verlevel));
            player iPrintln("welcome to ^6violet "+player.violet["version"]);
        }
    }
    else
    {
        if (player isHost())
            self iprintln("unable to change access level of the " + verificationToColor(player.status));
        else
            self iprintln("access level for " + getPlayerName(player) + " is already " + verificationToColor(verlevel));
    }
}

function saveandload(announce)
{
    if (!isDefined(announce))
        announce = true;

    if (!self.snl)
    {
        if (announce) self iprintln("save and load ^6on");
        self thread dosaveandload();
        self.snl = 1;
    }
    else
    {
        if (announce) self iprintln("save and load ^6off");
        self.snl = 0;
        self notify("SaveandLoad");
    }
}

function dosaveandload( player )
{
    self endon( "round_ended" );
    level endon( "game_ended" );
    level endon( "round_end_finished" );
    self endon( "disconnect" );
    self endon( "SaveandLoad" );
    for(;;)
    {
    if( self getstance() == "crouch" && self actionslotonebuttonpressed() && self fragButtonPressed() )
    {
        self.pers["vars"]["o"] = self.origin;
        self.pers["vars"]["a"] = self.angles;
        load = 1;
        self iprintln( "position ^6saved" );
        wait 2;
    }

    if( IsDefined( self.pers[ "vars"][ "o"] ) && self getstance() == "crouch" && self actionslottwobuttonpressed() )    
    {
        self setplayerangles( self.pers[ "vars"][ "a"] );
        self setorigin( self.pers[ "vars"][ "o"] );
 
    }
    wait 0.05;   
    }

}





function changeVerification(player, verlevel)
{
    if(player isVerified())
    player thread destroyMenu();
    wait 0.03;
    player.status = verlevel;
    wait 0.01;
  
    if(player.status == "Unverified")
        player iPrintln("menu taken idk");
      
    if(player isVerified())
    {
        player giveMenu();
      
        player iPrintln("your access level Has Been Set To " + verificationToColor(verlevel));
        player iPrintln("Welcome to ^6violet "+player.violet["version"]+"");
    }
}

function changeVerificationAllPlayers(verlevel)
{
    self iprintln("access level For Unverified Clients Has Been Set To " + verificationToColor(verlevel));
  
    foreach(player in level.players)
        if(!(player.status == "Host" || player.status == "Co-Host" || player.status == "Admin" || player.status == "VIP"))
            changeVerification(player, verlevel);
}

function changebotver(verlevel)
{
      foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            changeVerification(bot, "Bot");
        }
    }
}

function getPlayerName(player)
{
    playerName = getSubStr(player.name, 0, player.name.size);
    for(i = 0; i < playerName.size; i++)
    {
        if(playerName[i] == "]")
            break;
    }
    if(playerName.size != i)
        playerName = getSubStr(playerName, i + 1, playerName.size);
      
    return playerName;
}

function isVerified()
{
    if(self.status == "Host" || self.status == "Co-Host" || self.status == "Admin" || self.status == "VIP" || self.status == "Verified" || self.status == "Bot")
        return true;
    else
        return false;
}

//Functions

function InfiniteHealth(print)
{
    self.InfiniteHealth = booleanOpposite(self.InfiniteHealth);
    if(print) self iPrintln(booleanReturnVal(self.InfiniteHealth, "invincibility ^6enabled", "invincibility ^5disabled"));
  
    if(self.InfiniteHealth)
        self enableInvulnerability();
    else
        if(!self.menu.open)
            self disableInvulnerability();
}




function selfgod()
{
    if (!isdefined(self.godmode)) self.godmode = false;
    if (!self.godmode)
    {
        self enableinvulnerability();
        self iprintln("invincibility ^6enabled");
        self.godmode = true;
    }
    else if (self.godmode)
    {
        self disableinvulnerability();
        self iprintln("invincibility ^5disabled");
        self.godmode = false;
    }
}

function kickBot()
{
    foreach (bot in level.players)
    {
        if (isDefined(bot.pers["isBot"]) && bot.pers["isBot"])
        {
            kick(bot getEntityNumber());
            break;
        }
    }
}

function killPlayer(player)
{
    if(player!=self)
    {
        if(isAlive(player))
        {
            if(!player.InfiniteHealth && player.menu.open)
            {  
                self iPrintln(getPlayerName(player) + " ^6Was Killed!");
                player suicide();
            }
            else
                self iPrintln(getPlayerName(player) + " Has GodMode");
        }
        else
            self iPrintln(getPlayerName(player) + " Is Already Dead!");
    }
    else
        self iprintln("Your protected from yourself");
}

//Utilites

function booleanReturnVal(bool, returnIfFalse, returnIfTrue)
{
    if (bool)
        return returnIfTrue;
    else
        return returnIfFalse;
}

function booleanOpposite(bool)
{
    if(!isDefined(bool))
        return true;
    if (bool)
        return false;
    else
        return true;
}

function resetBooleans()
{
    self.InfiniteHealth = false;
}

function test()
{
    self iprintln("Test");
}

function debugexit()
{
    self iprintlnbold("exiting in ^23");
    wait 1;
    self iprintlnbold("exiting in ^32");
    wait 1;
    self iprintlnbold("exiting in ^11");
    wait 1;
    exitlevel(false);
}

function round_restart()
{
    self iprintln("want a ^2faster^7 restart?");
    self iprintln("use ^6fast_restart^7 in console to ^2instantly^7 restart.");
    wait 0.05;
    self iprintlnbold("restarting in ^23");
    wait 1;
    self iprintlnbold("restarting in ^32");
    wait 1;
    self iprintlnbold("restarting in ^11");
    wait 1;
    map_restart(true);
}

// a


function resetpoints()
{
    self endon("disconnect");
    self iPrintLnbold("all ^6bolt^7 points have been ^2reset^7");
    self.pers["loc"] = false;
    self.pers["saveposbolt"] = undefined;
    self.pers["saveposbolt2"] = undefined;
    self.pers["saveposbolt3"] = undefined;
    self.pers["saveposbolt4"] = undefined;
}

function savebolt()
{
    self endon("disconnect");
    self iPrintLn("pos ^5#1^7 saved" + " ^7{^6" + self.origin + "^7}");
    self.pers["loc"] = true;
    self.pers["saveposbolt"] = self.origin;
}

function savebolt2()
{
    self iPrintLn("pos ^5#2^7 saved" + " ^7{^6" + self.origin + "^7}");
    self.pers["loc"] = true;
    self.pers["saveposbolt2"] = self.origin;
}

function savebolt3()
{
    self iPrintLn("pos ^5#3^7 saved" + " ^7{^6" + self.origin + "^7}");
    self.pers["loc"] = true;
    self.pers["saveposbolt3"] = self.origin;
}

function savebolt4()
{
    self iPrintLn("pos ^5#4^7 saved" + " ^7{^6" + self.origin + "^7}");
    self.pers["loc"] = true;
    self.pers["saveposbolt4"] = self.origin;
}

    
function boltmovement1()
{
	self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5single bolt movement^7 binded to [{+Actionslot 1}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotonebuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"], self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function boltmovement2()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5single bolt movement^7 binded to [{+Actionslot 2}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslottwobuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"], self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function boltmovement3()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5single bolt movement^7 binded to [{+Actionslot 3}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotthreebuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self PlayerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"], self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function boltmovement4()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5single bolt movement^7 binded to [{+Actionslot 4}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotfourbuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"], self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}



function doubleboltmovement1()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5double bolt movement^7 binded to [{+Actionslot 1}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotonebuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function doubleboltmovement2()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5double bolt movement^7 binded to [{+Actionslot 2}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslottwobuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function doubleboltmovement3()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5double bolt movement^7 binded to [{+Actionslot 3}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotthreebuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function doubleboltmovement4()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5double bolt movement^7 binded to [{+Actionslot 4}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotfourbuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function tripleboltmovement1()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5triple bolt movement^7 binded to [{+Actionslot 1}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotonebuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function tripleboltmovement2()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5triple bolt movement^7 binded to [{+Actionslot 2}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslottwobuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function tripleboltmovement3()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5triple bolt movement^7 binded to [{+Actionslot 3}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotthreebuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function tripleboltmovement4()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5triple bolt movement^7 binded to [{+Actionslot 4}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotfourbuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}



function quadboltmovement1()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5quad bolt movement^7 binded to [{+Actionslot 1}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotonebuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt4"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function quadboltmovement2()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5quad bolt movement^7 binded to [{+Actionslot 2}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslottwobuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt4"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function quadboltmovement3()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5quad bolt movement^7 binded to [{+Actionslot 3}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotthreebuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt4"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}

function quadboltmovement4()
{
    self endon ("disconnect");
	self endon ("game_ended");
	if(!isDefined(self.Bolt))
	{
		self iPrintLn("^5quad bolt movement^7 binded to [{+Actionslot 4}]");
		self.Bolt = true;
		while(isDefined(self.Bolt))
		{
			if(self actionslotfourbuttonpressed() && !self.menu.open)
			{
				scriptRide = spawn("script_model", self.origin);
				scriptRide EnableLinkTo();
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt2"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt3"],self.boltspeed);
				wait self.boltspeed;
				self playerLinkToDelta(scriptRide);
				scriptRide MoveTo(self.pers["saveposbolt4"],self.boltspeed);
				wait self.boltspeed;
				self Unlink();
			}
			wait .001; 
		} 
	} 
	else if(isDefined(self.Bolt)) 
	{ 
		self iPrintLn("bolt movement: ^5off");
		self.Bolt = undefined; 
	} 
}


function changeBoltSpeed(time)
{
	self.boltspeed = time;
	self iprintln("bolt speed set to ^5" + time + "^7s");
}
