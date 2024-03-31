#if !macro

// Stuff
import openfl.utils.Assets as OpenFlAssets;
import lime.utils.Assets;
import haxe.Json;

import funkin_stuff.*;
import funkin_stuff.ui.FlxUIDropDownMenuCustom;

#if desktop
import funkin_stuff.Discord.DiscordClient;
import funkin_stuff.Discord;
#end

#if sys
import sys.io.File;
import sys.FileSystem;
#end

// Flixel Packages
import flixel.*;
import flixel.FlxG;
import flixel.FlxBasic;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxStringUtil;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxSave;
import flixel.util.FlxSort;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import flixel.input.keyboard.FlxKey;

// Backend Stuff
import backend.*;
import backend.ApplicationStuff as App;
import backend.Controls;
import backend.MusicBeatState;
import backend.MusicBeatSubstate;

// Data Stuff
import data.*;
//import data.GJData;
import data.Achievements;
import data.Conductor;
import data.Conductor.BPMChangeEvent;
import data.Rating;
import data.Section;
import data.Section.SwagSection;
import data.Song;
import data.Song.SwagSong;
import data.StageData;
import data.StageData.StageFile;
import data.WeekData;
import data.WeekData.WeekFile;

import cutscenes.CutsceneHandler;
import cutscenes.DialogueBoxPsych;
import cutscenes.DialogueBox;
import cutscenes.DialogueBoxPsych.DialogueAnimArray;
import cutscenes.DialogueBoxPsych.DialogueCharacterFile;
import cutscenes.DialogueBoxPsych.DialogueBoxPsych;
import cutscenes.DialogueBoxPsych.DialogueCharacter;

import obj.*;
import obj.Note;
import obj.Note.EventNote;
import obj.Alphabet;
import obj.Character;
import obj.Character.AnimArray;
import obj.Character.CharacterFile;
import obj.MenuCharacter;

import scripts.FunkinLua;

import shaders.*;
import shaders.ColorSwap;

import states.*;
import states.sub.*;
import states.sub.CustomFadeTransition;
import states.editors.*;
import states.editors.CharacterEditorState;
import states.editors.ChartingState;
import states.editors.WeekEditorState;
import states.editors.MasterEditorMenu;
import states.substates.*;

//import webs.GJApi;
#end