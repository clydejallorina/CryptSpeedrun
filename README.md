# Crypt Speedrunning Plugin

> Current Version: **0.0.2**

This project is a BepInEx plugin designed to be injected into Valefisk's psychological dating sim [Crypt](https://store.steampowered.com/app/2138700/Crypt/). The goal of this project is to provide a timer in-game to standardize timings for speedrunning hopefuls. Currently, the timer will start once the level fully loads. This *might* change in the future.

This has been a horrible waste of my time, and I wish you luck in yours.

## ASL Installation Instructions

> **WARNING:** As of version 0.0.2, the ASL script is still incomplete, and needs help. If you know how to hook it to the game properly, please send a pull request. Hopefully, I'll be able approve it for version 0.0.3 or 0.1.0.

Along with the mod files, there is also a specially crafted `Crypt.asl` file among the releases (when it's done). This is meant for use in LiveSplit's Auto-Splitter. This file is still under development, and would be distributed in a release once it's in a working state.

## Mod Installation Instructions

1. Download the appropriate zip folder for your OS in [Releases](https://github.com/clydejallorina/CryptSpeedrun/releases).
2. Figure out where Crypt is installed on your PC. This is done by right-clicking Crypt in the Steam library, hovering over `Manage`, and then clicking `Browse Local Files`.

![Steam Interface](readme_assets/steam_local_files.png)

3. Extract the downloaded zip folder's contents into the folder. The folder should look like the following:

![Local Files](readme_assets/local_files.png)

4. Open the game by opening `Crypt.exe` **directly** once to ensure that it's hooked. If done correctly, there should be an asterisk next to the version number as can be seen here:

![Crypt Main Menu](readme_assets/crypt_main_menu.png)

If there isn't an asterisk, try re-opening the game again. If it still doesn't show up, contact me on Discord at `@gristCollector#8688`.

## In-game Screenshots

![In-game Screenshot 1](readme_assets/ingame_sc1.jpg)
![In-game Screenshot 2](readme_assets/ingame_sc2.jpg)
![In-game Screenshot 3](readme_assets/ingame_sc3.jpg)
![Final Time Screenshot](readme_assets/crypt_final_time.png)

## Changelogs

**0.0.2** : Updated timings to start from level load, prototype autosplitter for LiveSplit

**0.0.1** : Initial Release for testing

## Mod Development Instructions

This is a simple BepInEx 5.4.21 plugin. Head on over to their [documentation](https://docs.bepinex.dev/v5.4.21/articles/dev_guide/plugin_tutorial/index.html) for more information.

As you can probably see in the listings, there's 3 empty folders. 2 of them have been emptied as it's mostly just NuGet caching (`obj`), and release artifacts (`bin`). `lib`, however, contains DLL files from the game (located in `Crypt_Data`). These files are specifically `Assembly-CSharp.dll` (the actual game DLL), `Unity.TextMeshPro.dll` (for showing text in the UI), and `UnityEngine.UI.dll` (for having access to the UI). These are not distributed with this repository since I don't want to be sued (even though it's probably okay? I'd rather not risk it).

In order to develop, you will need to manually copy-paste these DLLs yourself into the `lib` directory to build the plugin. Once that is done, you will be able to freely change and modify the game as you please. There could be more work in the future for a proper modding library for this game, but quite frankly it's not worth the effort.
