Notes:

i.      Player speed is either too high or the world is too small, pressing w once instantly colides with the wall

ii.     FPS seems to be dropping, we should add a fps counter to the top left in colour coded text (green = 60fps and above, orange = 30 - 60 fps and red is below 30)

iii.    Guns and enemies need to be drawn, i think it would be best to use a table to hold the raw data of the 3d assets and functions to create the assets from the data

iv.     Collision with walls results in the world not being rendered or something that seems similar, upon colision, the world goes black.

v.      Audio needs to be designed, it also has to be done in the game with functions. preferably in the main menu or on startup

vi.     Assets such as audio, guns and enemies should be stored as raw data in another lua script as seperate tables to be accessed and used to create audio files and such

vii.    Projectiles should be drawn coming out of the gun as tiny sprites, they should also collide with walls as well as enemies

viii.   The game should start with a loading screen, it should say LOADING... in the middle of the screen, with a growing progress bar at the bottom, after loading it should display the game title "Gloom" and a prompt saying "Press Any Key To Start", opening the main menu after any input is registered. (including mouse clicks but not mouse movement) Escape key will however quit the game instead of opening the main menu.

ix.     The map needs to be updated to show player and enemy positions, aswell as a cone of vision for the player to help orient themselves with. the map should also scale to the size of the player blip, not the player blip being sized to a large map in a small form. the map should go "off screen" of the map boundaries so it isnt fully drawn, just what is in the vicinity of the player.

x.      The ceiling and walls should be replaced with trees and building exteriors, the sky should be a sky box (also held as raw data then drawn) and the ground should be green with shading/shadowing to make it look like grass with random wees growing around