# XFactor Fame Or Shame for FiveM
This simple script adds the XFactor TV Show dynamics to Fame Or Shame stage in FiveM.

Made for an user driven event in [MapachesRP](https://mapachesrp.com/) FiveM server

## Requirement
If you don't have experience coding, you will need ESX to use it OOTB. We use ESX ui namespace to create the judge menu.

If you are not using ESX, you may edit [client/menu.lua](client/menu.lua) to implement your custom menu, or throw the server event `cibb-xfactorfos:pressButton` seding the judge ID as the first parameter and the button as second parameter (x, gold, reset)

For example you may create a command to trigger the button logic:

To do that, add this code to any server file

```
RegisterCommand("fosbutton", function(source, args)
    TriggerEvent('cibb-xfactorfos:pressButton',source, args[1])
end, true)
```

## Installation
1. Download the last release
2. Add this to your server.cfg:
```
    ensure cibb-xfactorfos-screen
    ensure cibb-xfactorfos
```
3. Move `cibb-xfactorfos` and `cibb-xfactorfos-screen` folders to your resources folder (You may move both to an `[fameorshame]` folder)
4. Enjoy (Go to Try yourself section to see how to use it)

## Previous configuration
Before anything you must configure the script. For that, open your local copy of  [config.lua](config.lua) file and change the judges identifiers.

In order to make it really flexible, you may choose between any idedntifier type (fivem, steam, license, etc). 

Add each judges identifier in `Config.judges` with thei in game name and be sure that `Config.identifier_used` is configured with your desired identifier provider.

## Try yourself
After make those changes, you are ready to test!

Go to Fame Or Shame stage (-235, -2001, 25) and walk to the judges table. If you are near enought you will see the call to action to open the Judges menu. If you are not able to see that, please be sure that the licences are well configured.

With the ACTION KEY (Generally E), you will open the judges menu. There you may select press the red X, press the golden button or reset.

Each judge will receive a X in the head to inform other judges and participants that they have pressed this button.

If 3 red X are pressed, then, a red lights animation will be triggered.

If the golde button is pressed, a yellow (Golden style) light animation will be triggered.

## Contact
Questions? Recomendations? Bugs? Contact me on Discord: Cibb#2487

## Pending stuffs
- The ininite loop to write the X in the judge's head is not really nice. Any way to improve that?
- I guess that there is a check to avoid play sounds to users that are faraway, but we need test that with other players
- What happen if I'm late to the party and one or more judges has the X?

## Thanks
- [plunkettscott/interact-sound](https://github.com/plunkettscott/interact-sound) for the Howler tip to play custom sounds 
- [FiveM thers](https://forum.cfx.re/t/release-generic-dui-2d-3d-renderer/131208) for the custom 3D renderer used in the screen

## Legal

### License

cibb-xfactorfos - XFactor Fame Or Shame for FiveM

Copyright (C) 2021 Cibb

This program Is free software: you can redistribute it And/Or modify it under the terms Of the GNU General Public License As published by the Free Software Foundation, either version 3 Of the License, Or (at your option) any later version.

This program Is distributed In the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty Of MERCHANTABILITY Or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License For more details.

You should have received a copy Of the GNU General Public License along with this program. If Not, see http://www.gnu.org/licenses/.
