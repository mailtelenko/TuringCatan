/*
 Jan 05 2017
 Liam Telenko
 This program plays the classic game "The Settlers of Catan" virtually
 */
%Import GUI
import GUI
%Open Window
var bgWindow := Window.Open ("graphics:max;max,position:center;center,nobuttonbar,nocursor")
drawfillbox (0, 0, maxx, maxy, black)
var mainWindow := Window.Open ("graphics:1000;600, position:center;center,nobuttonbar,offscreenonly,nocursor")
%Declare RGB Colours
var transparentBlue := RGB.AddColor (0, 42, 255)
%Declare Picture Variables
var boardBackground := Pic.FileNew ("Resources/backgroundBoard.jpg")
var sheepPic := Pic.FileNew ("Resources/sheep.jpg")
var brickPic := Pic.FileNew ("Resources/brick.jpg")
var orePic := Pic.FileNew ("Resources/ore.jpg")
var wheatPic := Pic.FileNew ("Resources/wheat.jpg")
var woodPic := Pic.FileNew ("Resources/wood.jpg")
var wheatTile := Pic.FileNew ("Resources/wheatTile.jpg")
var nextTurn := Pic.FileNew ("Resources/nextPlayer.jpg")
var nextTurnTrue := Pic.FileNew ("Resources/nextPlayerTrue.jpg")
%Declare Text Variables
var titleFont := Font.New ("Times New Roman:46:bold")
var titleLargeFont := Font.New ("Times New Roman:75:bold")
var mediumFont := Font.New ("Times New Roman:30")
var menuFont := Font.New ("Times New Roman:15:bold")
%Declare Global Variables
%Declare Arrays
var settlements : array 1 .. 55, 1 .. 2 of int := init(586,475,628,475,521,438,565,438,650,438,693,438,456,401,499,401,586,401,629,401,715,401,758,401,435,364,521,364,564,364,651,364,694,364,779,364,456,327,500,327,586,327,628,327,716,327,758,327,435,290,520,290,564,290,650,290,695,290,779,290,456,253,499,253,585,253,628,253,715,253,758,253,432,215,520,215,565,215,649,215,694,215,780,215,456,179,499,179,583,179,630,179,714,179,759,179,520,140,565,140,650,140,691,140,589,102,630,102,0,0)
var adjacents: array 1..54,1..3 of int := init(2,4,0,1,5,0,4,8,0,3,1,9,2,6,10,5,11,0,8,13,0,3,7,14,4,10,15,5,9,16,6,12,17,11,18,0,7,19,0,8,15,20,9,14,21,10,17,22,11,16,23,12,24,0,13,20,25,14,19,26,15,27,22,16,21,28,17,24,29,18,30,0,19,31,0,20,32,27,21,26,33,22,34,29,23,28,35,24,36,0,25,32,0,26,38,31,27,39,34,28,33,40,29,41,36,30,42,0,31,43,0,32,44,39,38,33,45,34,46,41,35,47,40,36,48,0,37,44,0,43,38,49,39,50,46,40,51,45,41,48,52,42,47,0,44,50,0,45,49,53,46,52,54,47,51,0,50,54,0,51,53,0)
var surrounding:array 1..19, 1..3 of int := init(1,4,9,3,8,14,5,10,16,7,13,19,9,15,16,11,17,23,14,20,26,16,22,28,19,25,31,21,27,33,23,29,35,26,32,38,28,34,40,31,37,43,33,39,45,35,41,47,38,44,49,40,46,51,45,50,53)
var typeLocations : array 1 .. 19, 1 .. 2 of int := init (608, 440, 542, 404, 672, 404, 477, 366, 607, 366, 737, 366, 543, 327, 673, 327, 477, 290, 608, 290, 737, 290, 543, 253, 673, 253, 478, 215, 608, 215, 737, 215, 543, 178, 673, 178, 608, 140)
var roads : array 1 .. 60, 1 .. 3 of int
var cities : array 1 .. 16, 1 .. 2 of int
var tile : array 1 .. 19, 1 .. 2 of int
var settled : array 0 .. 54 of int
var wood, sheep, brick, ore, wheat, roadCounter, cityCounter, settlementCounter, victoryPoints, initSettlements, initRoads : array 1 .. 4 of int := init (0, 0, 0, 0)
var height, altitude : array 1 .. 50 of int
var name : array 1 .. 4 of string := init ("", "", "", "")
var userColour : array 1 .. 4 of int := init (4, 0, 1, 41)
var adjacentSettlements : array 1 .. 3 of int := init (0, 0, 0)
%Declare Variables
var pauseGet : string (1)
var namesFinished := false
var winner : string
var chosen, fontWidth, roll, playerAmount, returnClick, robber, turnCounter, mostRoads, exitTrue : int := 0
var turn : int := 0
%Declare procedures
forward proc introAnimation
forward proc mainMenu
forward proc setup
forward proc exitProgram
forward proc rules
forward proc continueBtnProc
forward proc game
forward proc buildSettlement
forward proc drawBack
forward proc randomTiles
forward proc drawTiles
forward proc updateRes
forward proc buildRoad
forward proc buildCity
forward proc distributeRes
forward proc gameOver
forward proc trade
%Declare GUI Elements
var continueBtn := GUI.CreateButtonFull (50, 20, 900, "Continue", continueBtnProc, 100, "^C", false)
GUI.Disable (continueBtn)
%Play Music
process music
    loop
	exit when exitTrue = 1
	Music.PlayFile ("Resources/music/music.mp3")
    end loop
end music
%Introduction Animation
body proc introAnimation
    %Set heights of mountains
    for y : 1 .. 50
	height (y) := Rand.Int (50, 100)
	altitude (y) := Rand.Int (100, 150)
    end for
    for x : 1 .. 1000
	%Draw Background
	drawfilloval (500 + (x div 10), 100, 900, 800, red)
	drawfilloval (500 + (x div 10), 100, 600, 500, brightred)
	drawfilloval (500 + (x div 10), 100, 400, 300, yellow)
	%Draw Mountains
	for y : 1 .. 20
	    drawfilloval (-850 + (y * 120) + (x div 7), altitude (y), 100, height (y) div .5, 18)
	end for
	for y : 1 .. 20
	    drawfilloval (-750 + (y * 100) + (x div 4), height (y), 100, altitude (y), black)
	end for
	%Draw Text
	Font.Draw ("The Settlers Of", -450 + (x div 2), 530, titleFont, yellow)
	Font.Draw ("Catan", -385 + (x div 2), 430, titleLargeFont, yellow)
	Draw.ThickLine (-450 + (x div 2), 520, -50 + (x div 2), 520, 2, yellow)
	delay (2)
	View.Update
    end for
    %Confirm User
    Font.Draw ("Press any key to continue...", 520, 25, mediumFont, white)
    View.Update
    getch (pauseGet)
    %Animate into main menu
    for x : 1 .. 1000
	drawfillbox (0, 0, 0 + x, 800, 114)
	if x > 500 then
	    Font.Draw ("The Settlers Of", 50 + ((x - 500) div 2), 530, titleFont, yellow)
	    Font.Draw ("Catan", 115 + ((x - 500) div 2), 430, titleLargeFont, yellow)
	    Draw.ThickLine (50 + ((x - 500) div 2), 520, 450 + ((x - 500) div 2), 520, 2, yellow)
	else
	    Font.Draw ("The Settlers Of", 50, 530, titleFont, yellow)
	    Font.Draw ("Catan", 115, 430, titleLargeFont, yellow)
	    Draw.ThickLine (50, 520, 450, 520, 2, yellow)
	end if
	delay (1)
	View.Update
    end for
    mainMenu
end introAnimation

body proc mainMenu
    %Draw main menu background
    drawfillbox (0, 0, 1000, 800, 114)
    drawfillbox (125, 125, 875, 275, 111)
    drawfillbox (130, 130, 870, 270, 41)
    var x, y, button : int := 0
    Font.Draw ("The Settlers Of", 300, 530, titleFont, yellow)
    Font.Draw ("Catan", 365, 430, titleLargeFont, yellow)
    Draw.ThickLine (300, 520, 700, 520, 2, yellow)
    drawfillbox (145, 145, 355, 255, red)
    drawfillbox (395, 145, 605, 255, red)
    drawfillbox (645, 145, 855, 255, red)
    drawfillbox (150, 150, 350, 250, yellow)
    drawfillbox (400, 150, 600, 250, yellow)
    drawfillbox (650, 150, 850, 250, yellow)
    Font.Draw ("Rules", 205, 185, mediumFont, black)
    Font.Draw ("Play", 465, 185, mediumFont, black)
    Font.Draw ("Exit", 715, 185, mediumFont, black)
    loop
	%Draw default buttons
	drawfillbox (150, 150, 350, 250, yellow)
	drawfillbox (400, 150, 600, 250, yellow)
	drawfillbox (650, 150, 850, 250, yellow)
	Font.Draw ("Rules", 205, 185, mediumFont, black)
	Font.Draw ("Play", 465, 185, mediumFont, black)
	Font.Draw ("Exit", 715, 185, mediumFont, black)
	%Check mouse position and if on button
	mousewhere (x, y, button)
	if x > 140 and x < 860 and y > 145 and y < 255 then
	    if x >= 145 and x <= 355 then
		drawfillbox (150, 150, 350, 250, green)
		Font.Draw ("Rules", 205, 185, mediumFont, white)
		if button = 1 then
		    rules
		    exit
		end if
	    elsif x >= 395 and x <= 605 then
		drawfillbox (400, 150, 600, 250, green)
		Font.Draw ("Play", 465, 185, mediumFont, white)
		if button = 1 then
		    setup
		    exit
		end if
	    elsif x >= 645 and x <= 855 then
		drawfillbox (650, 150, 850, 250, green)
		Font.Draw ("Exit", 715, 185, mediumFont, white)
		if button = 1 then
		    exitTrue := 1
		    exitProgram
		    exit
		end if
	    end if
	end if
	View.Update
    end loop
end mainMenu

body proc rules
    %Draw rules background
    cls
    drawfillbox (0, 0, 1000, 800, 114)
    Font.Draw ("Loading...", 450, 250, titleFont, white)
    drawfillbox (0, 600, 50, 550, red)
    drawfillbox (5, 595, 45, 555, yellow)
    Draw.ThickLine (10, 575, 40, 575, 3, black)
    Draw.ThickLine (10, 575, 15, 580, 3, black)
    Draw.ThickLine (10, 575, 15, 570, 3, black)
    var pageCounter, x, y, button := 0
    drawfillbox (0, 195, 55, 405, red)
    drawfillbox (0, 200, 50, 400, yellow)
    Draw.ThickLine (10, 300, 40, 220, 4, black)
    Draw.ThickLine (10, 300, 40, 380, 4, black)
    drawfillbox (1000, 195, 945, 405, red)
    drawfillbox (1000, 200, 950, 400, yellow)
    Draw.ThickLine (990, 300, 960, 220, 4, black)
    Draw.ThickLine (990, 300, 960, 380, 4, black)
    View.Update
    loop
	%Draw image from file according to page #
	var rulePicture := Pic.FileNew ("Resources/Rules/Page " + intstr (pageCounter) + ".jpg")
	Pic.Draw (rulePicture, 268, 0, 0)
	View.Update
	loop
	    %Draw default button states
	    drawfillbox (0, 600, 50, 550, red)
	    drawfillbox (5, 595, 45, 555, yellow)
	    Draw.ThickLine (10, 575, 40, 575, 3, black)
	    Draw.ThickLine (10, 575, 15, 580, 3, black)
	    Draw.ThickLine (10, 575, 15, 570, 3, black)
	    drawfillbox (0, 200, 50, 400, yellow)
	    Draw.ThickLine (10, 300, 40, 220, 4, black)
	    Draw.ThickLine (10, 300, 40, 380, 4, black)
	    drawfillbox (1000, 200, 950, 400, yellow)
	    Draw.ThickLine (990, 300, 960, 220, 4, black)
	    Draw.ThickLine (990, 300, 960, 380, 4, black)
	    %Check where mouse is and if on button
	    mousewhere (x, y, button)
	    if x <= 55 and x >= 0 and y <= 405 and y >= 195 then
		drawfillbox (0, 200, 50, 400, green)
		Draw.ThickLine (10, 300, 40, 220, 4, black)
		Draw.ThickLine (10, 300, 40, 380, 4, black)
		if pageCounter > 0 and button = 1 then
		    pageCounter := pageCounter - 1
		end if
	    elsif x <= 1000 and x >= 945 and y <= 405 and y >= 195 then
		drawfillbox (1000, 200, 950, 400, green)
		Draw.ThickLine (990, 300, 960, 220, 4, black)
		Draw.ThickLine (990, 300, 960, 380, 4, black)
		if pageCounter < 11 and button = 1 then
		    pageCounter := pageCounter + 1
		end if
	    elsif x >= 0 and x <= 50 and y >= 550 and y <= 600 then
		drawfillbox (5, 595, 45, 555, green)
		Draw.ThickLine (10, 575, 40, 575, 3, black)
		Draw.ThickLine (10, 575, 15, 580, 3, black)
		Draw.ThickLine (10, 575, 15, 570, 3, black)
		if button = 1 then
		    mainMenu
		    exit
		end if
	    end if
	    exit when button = 1
	    View.Update
	end loop
	%Check if exit button is hovered
	if x >= 0 and x <= 50 and y >= 550 and y <= 600 and button = 1 then
	    exit
	end if
	%Check if mouse is released
	loop
	    mousewhere (x, y, button)
	    exit when button = 0
	end loop
	%Remove picture from memory
	Pic.Free (rulePicture)
    end loop
end rules

%SET NAMES TO VARIABLES FORM GUI
procedure player1 (P1 : string)
    name (1) := P1
end player1
procedure player2 (P2 : string)
    name (2) := P2
end player2
procedure player3 (P3 : string)
    name (3) := P3
end player3
procedure player4 (P4 : string)
    if P4 = "" then
	name (4) := "noPlayer"
    else
	name (4) := P4
    end if
end player4
body procedure continueBtnProc
    if name (1) not= "" and name (2) not= "" and name (3) not= "" and name (4) not= "" then
	GUI.Disable (continueBtn)
	game
    end if
end continueBtnProc

body proc setup
    %Draw background for setup
    drawfillbox (0, 0, 1000, 600, 114)
    drawfillbox (0, 600, 50, 550, red)
    drawfillbox (5, 595, 45, 555, yellow)
    Draw.ThickLine (10, 575, 40, 575, 3, black)
    Draw.ThickLine (10, 575, 15, 580, 3, black)
    Draw.ThickLine (10, 575, 15, 570, 3, black)
    drawfillbox (0, 0, 1000, 650, 114)
    drawfillbox (10, 145, 240, 500, red)
    drawfillbox (260, 145, 490, 500, red)
    drawfillbox (510, 145, 740, 500, red)
    drawfillbox (760, 145, 990, 500, red)
    drawfillbox (765, 150, 985, 495, yellow)
    drawfillbox (515, 150, 735, 495, yellow)
    drawfillbox (265, 150, 485, 495, yellow)
    drawfillbox (15, 150, 235, 495, yellow)
    %Draw labels
    Font.Draw ("Setup", 425, 525, titleFont, yellow)
    View.Set ("nooffscreenonly")
    %Create text fields
    var textBox1 := GUI.CreateTextField (25, 350, 200, "", player1)
    var textBox2 := GUI.CreateTextField (275, 350, 200, "", player2)
    var textBox3 := GUI.CreateTextField (525, 350, 200, "", player3)
    var textBox4 := GUI.CreateTextField (775, 350, 200, "", player4)
    GUI.Enable (continueBtn)
    GUI.Show (continueBtn)
    for x : 1 .. 4
	Font.Draw ("Name:", 25 + ((x - 1) * 250), 380, menuFont, black)
	Font.Draw ("Player " + intstr (x), 65 + ((x - 1) * 250), 445, mediumFont, black)
	Font.Draw ("Colour", 95 + ((x - 1) * 250), 270, menuFont, black)
	drawfillbox (85 + ((x - 1) * 250), 250, 165 + ((x - 1) * 250), 170, red)
    end for
    drawfillbox (90, 245, 160, 175, brightred)
    drawfillbox (340, 245, 410, 175, white)
    drawfillbox (590, 245, 660, 175, blue)
    drawfillbox (840, 245, 910, 175, 41)
    View.Update
end setup

body proc game
    %Declare Variables
    var mouseX, mouseY, click : int
    %Set Variables
    var turnCounter, fontWidth, chosen := 0
    winner := " "
    %Set arrays
    for x : 0 .. 54
	settled (x) := 999
    end for
    for x : 1 .. 19
	tile (x, 1) := 888
    end for
    for x : 1 .. 60
	roads (x, 1) := 999
    end for
    for x : 1 .. 16
	cities (x, 1) := 999
    end for
    for x : 1 .. 4
	roadCounter (x) := 0
	cityCounter (x) := 0
	settlementCounter (x) := 0
	wood (x) := 0
	sheep (x) := 0
	brick (x) := 0
	ore (x) := 0
	wheat (x) := 0
	victoryPoints (x) := 0
    end for
    for x : 1 .. 3
	adjacentSettlements (x) := 0
    end for
    randomTiles
    cls
    View.Set ("offscreenonly")
    %Declare tile types
    for x : 1 .. 19
	loop
	    tile (x, 1) := Rand.Int (1, 12)
	    if tile (x, 1) = 7 then
	    else
		exit
	    end if
	end loop
    end for
    %Main program loop
    loop
	%TURN COUNTING
	turnCounter := turnCounter + 1
	%Check amount of players (3/4), if it is the first round (setup round), go from player 1 -> 4/3 -> 1 and give resources for settlement and road
	if name (4) = "noPlayer" then
	    if turnCounter <= 6 then
		if turn < 4 then
		    turn := turn + 1
		end if
		if turnCounter = 4 then
		    turn := 3
		elsif turnCounter = 5 then
		    turn := 2
		elsif turnCounter = 6 then
		    turn := 1
		end if
		wood (turn) := 2
		brick (turn) := 2
		wheat (turn) := 1
		sheep (turn) := 1
	    else
		if turn < 3 then
		    turn := turn + 1
		else
		    turn := 1
		end if
	    end if
	else
	    View.Update
	    if turnCounter <= 8 then
		if turnCounter < 5 then
		    turn := turn + 1
		end if
		if turnCounter = 5 then
		    turn := 4
		elsif turnCounter = 6 then
		    turn := 3
		elsif turnCounter = 7 then
		    turn := 2
		elsif turnCounter = 8 then
		    turn := 1
		end if
		wood (turn) := 2
		brick (turn) := 2
		wheat (turn) := 1
		sheep (turn) := 1
	    else
		if turn < 4 then
		    turn := turn + 1
		else
		    turn := 1
		end if
	    end if
	end if
	%Check Victory Points and if there is a winner. Find the player with the most roads and then add cities, settlements, and most road points.
	for x : 1 .. 4
	    mostRoads := roadCounter (1)
	    for y : 2 .. 4
		if mostRoads = roadCounter (y) then
		    mostRoads := 999
		elsif mostRoads < roadCounter (y) then
		    mostRoads := roadCounter (y)
		end if
	    end for
	    if mostRoads = roadCounter (x) and mostRoads > 5 then
		victoryPoints (x) := (cityCounter (x) * 2) + settlementCounter (x) + 2
	    else
		victoryPoints (x) := (cityCounter (x) * 2) + settlementCounter (x)
	    end if
	    if victoryPoints (x) = 10 then
		winner := intstr (x)
		exit
	    end if
	end for
	%Draw background image, sidebar, and other images
	drawfillbox (0, 0, 1000, 600, 126)
	drawBack
	drawTiles
	drawfillbox (0, 0, 200, 600, red)
	drawfillbox (0, 5, 195, 595, 114)
	drawfillbox (5, 590, 185, 520, red)
	drawfillbox (10, 585, 180, 525, yellow)
	drawfillbox (5, 425, 90, 510, red)
	drawfillbox (100, 425, 185, 510, red)
	drawfillbox (5, 420, 90, 335, red)
	drawfillbox (100, 420, 185, 335, red)
	drawfillbox (53, 245, 138, 330, red)
	drawfillbox (10, 235, 180, 190, red)
	drawfillbox (15, 230, 175, 195, yellow)
	drawfillbox (10, 140, 180, 185, red)
	drawfillbox (15, 145, 175, 180, yellow)
	drawfillbox (10, 90, 180, 135, red)
	drawfillbox (15, 95, 175, 130, yellow)
	drawfillbox (10, 40, 180, 85, red)
	drawfillbox (15, 45, 175, 80, yellow)
	drawfillbox (915, 515, 1000, 600, red)
	drawfillbox (915, 0, 1000, 85, red)
	drawfillbox (921, 6, 994, 79, yellow)
	updateRes
	Pic.Draw (nextTurn, 920, 520, 0)
	%Restrict name length and position it
	if length (name (turn)) > 9 then
	    fontWidth := Font.Width (name (turn) (1 .. 9), mediumFont)
	    Font.Draw (name (turn) (1 .. 9), 10 + (170 - fontWidth) div 2, 543, mediumFont, black)
	else
	    fontWidth := Font.Width (name (turn), mediumFont)
	    Font.Draw (name (turn), 10 + (170 - fontWidth) div 2, 543, mediumFont, black)
	end if
	%Button Text
	Font.Draw ("Settlement", 50, 207, menuFont, black)
	Font.Draw ("Road", 75, 158, menuFont, black)
	Font.Draw ("City", 79, 107, menuFont, black)
	Font.Draw ("Trade", 70, 57, menuFont, black)
	View.Update
	%Roll dice!
	var temp : string
	roll := Rand.Int (1, 12)
	%Check if first round. Force player to build settlement/road if so
	if name (4) = "noPlayer" then
	    if turnCounter <= 6 then
		buildSettlement
		buildRoad
		roll := 0
	    end if
	else
	    if turnCounter <= 8 then
		buildSettlement
		buildRoad
		roll := 0
	    end if
	end if
	%Distribute Resources
	distributeRes
	%Move robber if roll is 7
	if roll = 7 then
	    robber := Rand.Int (1, 19)
	    drawBack
	    drawTiles
	end if
	%Display Roll
	drawfillbox (915, 0, 1000, 85, red)
	drawfillbox (921, 6, 994, 79, yellow)
	fontWidth := Font.Width (intstr (roll), mediumFont)
	Font.Draw (intstr (roll), 921 + (73 - fontWidth) div 2, 28, mediumFont, black)
	loop
	    %Check where mouse is and if it is over a button.
	    drawfillbox (915, 515, 1000, 600, red)
	    Pic.Draw (nextTurn, 920, 520, 0)
	    drawfillbox (15, 230, 175, 195, yellow)
	    Font.Draw ("Settlement", 50, 207, menuFont, black)
	    drawfillbox (15, 145, 175, 180, yellow)
	    Font.Draw ("Road", 75, 158, menuFont, black)
	    drawfillbox (15, 95, 175, 130, yellow)
	    Font.Draw ("City", 79, 107, menuFont, black)
	    drawfillbox (15, 45, 175, 80, yellow)
	    Font.Draw ("Trade", 70, 57, menuFont, black)
	    mousewhere (mouseX, mouseY, click)
	    if mouseX > 15 and mouseX < 175 and mouseY > 190 and mouseY < 225 then
		drawfillbox (15, 230, 175, 195, green)
		Font.Draw ("Settlement", 50, 207, menuFont, white)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    buildSettlement
		end if
	    elsif mouseX > 15 and mouseX < 175 and mouseY > 145 and mouseY < 185 then
		drawfillbox (15, 145, 175, 180, green)
		Font.Draw ("Road", 75, 158, menuFont, white)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    buildRoad
		end if
	    elsif mouseX > 15 and mouseX < 175 and mouseY > 90 and mouseY < 135 then
		drawfillbox (15, 95, 175, 130, green)
		Font.Draw ("City", 79, 107, menuFont, white)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    buildCity
		end if
	    elsif mouseX > 15 and mouseX < 175 and mouseY > 40 and mouseY < 85 then
		drawfillbox (15, 45, 175, 80, green)
		Font.Draw ("Trade", 70, 57, menuFont, white)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    trade
		end if
	    elsif mouseX >= 920 and mouseX <= 995 and mouseY <= 595 and mouseY >= 520 then
		Pic.Draw (nextTurnTrue, 920, 520, 0)
		View.Update
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			if click = 0 then
			    exit
			end if
		    end loop
		    exit
		end if
	    end if
	    View.Update
	    exit when winner not= " "
	end loop
	exit when winner not= " "
    end loop
    %Show winner and end game
    gameOver
end game

body proc updateRes
    %Draw resource images
    Pic.Draw (woodPic, 10, 430, 0)
    Pic.Draw (brickPic, 105, 430, 0)
    Pic.Draw (wheatPic, 105, 340, 0)
    Pic.Draw (sheepPic, 10, 340, 0)
    Pic.Draw (orePic, 58, 250, 0)
    %Draw amount of resources
    fontWidth := Font.Width (intstr (sheep (turn)), mediumFont)
    Font.Draw (intstr (sheep (turn)), 45 - (fontWidth div 2), 365, mediumFont, white)
    fontWidth := Font.Width (intstr (ore (turn)), mediumFont)
    Font.Draw (intstr (ore (turn)), 95 - (fontWidth div 2), 273, mediumFont, white)
    fontWidth := Font.Width (intstr (wood (turn)), mediumFont)
    Font.Draw (intstr (wood (turn)), 45 - (fontWidth div 2), 452, mediumFont, white)
    fontWidth := Font.Width (intstr (brick (turn)), mediumFont)
    Font.Draw (intstr (brick (turn)), 145 - (fontWidth div 2), 452, mediumFont, white)
    fontWidth := Font.Width (intstr (wheat (turn)), mediumFont)
    Font.Draw (intstr (wheat (turn)), 145 - (fontWidth div 2), 365, mediumFont, white)
end updateRes

body proc buildSettlement
    %Declare variables
    var mouseX, mouseY, click, roadTrue : int := 0
    loop
	roadTrue := 0
	%Check where mouse is and if it is over an available node. If it is clicked check for available resources and note the location and player.
	drawfillbox (15, 230, 175, 195, yellow)
	Font.Draw ("   Cancel", 50, 207, menuFont, black)
	chosen := 0
	for x : 1 .. 3
	    adjacentSettlements (x) := 0
	end for
	mousewhere (mouseX, mouseY, click)
	if mouseX < 15 and mouseX > 175 and mouseY < 190 and mouseY > 225 then
	    drawBack
	    drawTiles
	end if
	for x : 1 .. 54
	    if mouseX >= settlements (x, 1) - 3 and mouseX <= settlements (x, 1) + 3 and mouseY <= settlements (x, 2) + 3 and mouseY >= settlements (x, 2) - 3 and settled (x) = 999 then
		drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, yellow)
		if click = 1 then
		    View.Update
		    if settled (adjacents (x, 1)) >= 998 and settled (adjacents (x, 2)) >= 998 and settled (adjacents (x, 3)) >= 998 then
			if adjacents (x, 3) = 0 then
			    for y : 1 .. 2
				if whatdotcolour ((settlements (adjacents (x, y), 1) + settlements (x, 1)) div 2, ((settlements (adjacents (x, y), 2) + settlements (x, 2)) div 2)) = userColour (turn)
					then
				    roadTrue := 1
				end if
			    end for
			else
			    for y : 1 .. 3
				if whatdotcolour ((settlements (adjacents (x, y), 1) + settlements (x, 1)) div 2, ((settlements (adjacents (x, y), 2) + settlements (x, 2)) div 2)) =
					userColour (turn) then
				    roadTrue := 1
				end if
			    end for
			end if
			if name (4) = "noPlayer" then
			    if turnCounter <= 6 and initSettlements (turn) < 2 then
				roadTrue := 1
			    end if
			else
			    if turnCounter <= 8 and initSettlements (turn) < 2 then
				roadTrue := 1
			    end if
			end if
			View.Update
			if brick (turn) >= 1 and wheat (turn) >= 1 and wood (turn) >= 1 and sheep (turn) >= 1 and settlementCounter (turn) < 5 and roadTrue = 1 then
			    settled (x) := userColour (turn)
			    chosen := x
			    brick (turn) := brick (turn) - 1
			    wheat (turn) := wheat (turn) - 1
			    wood (turn) := wood (turn) - 1
			    sheep (turn) := sheep (turn) - 1
			    updateRes
			    drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, settled (x))
			    settlementCounter (turn) := settlementCounter (turn) + 1
			    settled (adjacents (x, 1)) := 998
			    settled (adjacents (x, 2)) := 998
			    if adjacents (x, 3) not= 0 then
				settled (adjacents (x, 3)) := 998
			    end if
			    if initSettlements (turn) < 2 then
				initSettlements (turn) := initSettlements (turn) + 1
			    end if
			    roadTrue := 0
			end if
		    end if
		    exit
		end if
	    elsif mouseX > 15 and mouseX < 175 and mouseY > 190 and mouseY < 225 then
		drawfillbox (15, 230, 175, 195, green)
		Font.Draw ("   Cancel", 50, 207, menuFont, white)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    returnClick := 1
		    exit
		end if
	    else
		if settled (x) not= 999 and settled (x) not= 998 then
		    drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, settled (x))
		elsif settled (x) not= 998 then
		    drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, green)
		end if
	    end if
	end for
	exit when chosen not= 0 or returnClick = 1
	View.Update
    end loop
    returnClick := 0
    drawBack
    drawTiles
    for x : 1 .. 54
	if settled (x) not= 999 and settled (x) not= 998 then
	    drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, settled (x))
	end if
    end for
    View.Update
end buildSettlement

body proc buildRoad
    %Check if all the roads have been used
    if roadCounter (turn) not= 15 then
	var mouseX, mouseY, click, counter, roadTrue : int := 0
	var selection : array 1 .. 2 of int := init (0, 0)
	%Check where mouse is and if nodes are available. Draw a line between the two nodes and mark the location and player.
	loop
	    roadTrue := 0
	    drawfillbox (15, 145, 175, 180, yellow)
	    Font.Draw ("   Cancel", 50, 158, menuFont, black)
	    chosen := 0
	    mousewhere (mouseX, mouseY, click)
	    if mouseX < 15 and mouseX > 175 and mouseY < 190 and mouseY > 225 then
		drawBack
		drawTiles
	    end if
	    for x : 1 .. 54
		if mouseX >= settlements (x, 1) - 3 and mouseX <= settlements (x, 1) + 3 and mouseY <= settlements (x, 2) + 3 and mouseY >= settlements (x, 2) - 3 then
		    drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, yellow)
		    View.Update
		    if click = 1 then
			loop
			    mousewhere (mouseX, mouseY, click)
			    exit when click = 0
			end loop
			if counter = 0 then
			    counter := counter + 1
			    selection (counter) := x
			elsif counter = 1 then
			    if x = adjacents (selection (1), 1) or x = adjacents (selection (1), 2) or x = adjacents (selection (1), 3) then
				counter := counter + 1
				selection (counter) := x
			    end if
			    if adjacents (x, 3) = 0 then
				for y : 1 .. 2
				    if whatdotcolour ((settlements (adjacents (x, y), 1) + settlements (selection (1), 1)) div 2, ((settlements (adjacents (x, y), 2) + settlements (selection (1), 2)) 
					div 2)) = userColour (turn)
					    then
					roadTrue := 1
				    end if
				end for
			    else
				for y : 1 .. 3
				    if whatdotcolour ((settlements (adjacents (x, y), 1) + settlements (selection (1), 1)) div 2, ((settlements (adjacents (x, y), 2) + settlements (selection (1), 2)) 
					div 2)) =
					    userColour (turn) then
					roadTrue := 1
				    end if
				end for
			    end if
			    if name (4) = "noPlayer" then
				if turnCounter <= 6 and initRoads (turn) < 2 then
				    roadTrue := 1
				end if
			    else
				if turnCounter <= 8 and initRoads (turn) < 2 then
				    roadTrue := 1
				end if
			    end if
			    if selection (1) not= 0 and selection (2) not= 0 and wood (turn) not= 0 and brick (turn) not= 0 and selection (1) not= selection (2) and roadTrue = 1 then
				roadCounter (turn) := roadCounter (turn) + 1
				Draw.ThickLine (settlements (selection (1), 1), settlements (selection (1), 2), settlements (selection (2), 1), settlements (selection (2), 2), 5,
				    userColour (turn))
				roads ((roadCounter (1) + roadCounter (2) + roadCounter (3) + roadCounter (4) + 1), 1) := selection (1)
				roads ((roadCounter (1) + roadCounter (2) + roadCounter (3) + roadCounter (4) + 1), 2) := selection (2)
				roads ((roadCounter (1) + roadCounter (2) + roadCounter (3) + roadCounter (4) + 1), 3) := userColour (turn)
				brick (turn) := brick (turn) - 1
				wood (turn) := wood (turn) - 1
				updateRes
				roadTrue := 0
				if initRoads (turn) < 2 then
				    initRoads (turn) := initRoads (turn) + 1
				end if
				View.Update
				exit
			    end if
			end if
		    end if
		elsif mouseX > 15 and mouseX < 175 and mouseY > 145 and mouseY < 180 then
		    drawfillbox (15, 145, 175, 180, green)
		    Font.Draw ("   Cancel", 50, 158, menuFont, white)
		    View.Update
		    if click = 1 then
			loop
			    mousewhere (mouseX, mouseY, click)
			    exit when click = 0
			end loop
			returnClick := 1
			exit
		    end if
		else
		    if counter not= 0 and selection (1) = x or selection (2) = x then
			drawfillbox (settlements (selection (1), 1) - 3, settlements (selection (1), 2) - 3, settlements (selection (1), 1) + 3, settlements (selection (1), 2) + 3, yellow)
			if counter > 1 then
			    drawfillbox (settlements (selection (2), 1) - 3, settlements (selection (2), 2) - 3, settlements (selection (2), 1) + 3, settlements (selection (2), 2) + 3, yellow)
			end if
		    elsif settled (x) not= 999 and settled (x) not= 998 then
			drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, settled (x))
		    elsif settled (x) = 999 and counter = 0 then
			for y : 1 .. 54
			    drawfillbox (settlements (y, 1) - 3, settlements (y, 2) - 3, settlements (y, 1) + 3, settlements (y, 2) + 3, green)
			end for
		    elsif counter > 0 then
			drawBack
			drawTiles
			drawfillbox (settlements (adjacents (selection (1), 1), 1) - 3, settlements (adjacents (selection (1), 1), 2) - 3, settlements (adjacents (selection (1), 1), 1) + 3,
			    settlements (adjacents (selection (1), 1), 2) + 3, green)
			drawfillbox (settlements (adjacents (selection (1), 2), 1) - 3, settlements (adjacents (selection (1), 2), 2) - 3, settlements (adjacents (selection (1), 2), 1) + 3,
			    settlements (adjacents (selection (1), 2), 2) + 3, green)
			if adjacents (selection (1), 3) not= 0 then
			    drawfillbox (settlements (adjacents (selection (1), 3), 1) - 3, settlements (adjacents (selection (1), 3), 2) - 3, settlements (adjacents (selection (1), 3), 1) +
				3,
				settlements (adjacents (selection (1), 3), 2) + 3, green)
			end if
		    end if
		end if
	    end for
	    exit when chosen not= 0 or returnClick = 1 or counter = 2
	end loop
	returnClick := 0
	drawBack
	drawTiles
	for x : 1 .. 54
	    if settled (x) not= 999 and settled (x) not= 998 then
		drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, settled (x))
	    end if
	end for
	View.Update
    end if
end buildRoad

body proc buildCity
    var mouseX, mouseY, click : int
    %Check if a settlement is built and if there are enough resources. Note the location and player who builds it.
    loop
	drawfillbox (15, 95, 175, 130, yellow)
	Font.Draw ("   Cancel", 50, 107, menuFont, black)
	chosen := 0
	mousewhere (mouseX, mouseY, click)
	if mouseX < 15 and mouseX > 175 and mouseY < 190 and mouseY > 225 then
	    drawBack
	    drawTiles
	end if
	for x : 1 .. 54
	    if mouseX >= settlements (x, 1) - 3 and mouseX <= settlements (x, 1) + 3 and mouseY <= settlements (x, 2) + 3 and mouseY >= settlements (x, 2) - 3 and settled (x) =
		    userColour (turn) then
		drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, green)
		if click = 1 then
		    if ore (turn) >= 3 and wheat (turn) >= 2 and cityCounter (turn) < 4 then
			settled (x) := userColour (turn)
			ore (turn) := ore (turn) - 3
			wheat (turn) := wheat (turn) - 2
			updateRes
			cities ((cityCounter (1) + cityCounter (2) + cityCounter (3) + cityCounter (4) + 1), 1) := x
			cities ((cityCounter (1) + cityCounter (2) + cityCounter (3) + cityCounter (4) + 1), 2) := userColour (turn)
			cityCounter (turn) := cityCounter (turn) + 1
			settlementCounter (turn) := settlementCounter (turn) - 1
			View.Update
			returnClick := 1
		    end if
		    exit
		end if
	    elsif mouseX > 15 and mouseX < 175 and mouseY > 95 and mouseY < 130 then
		drawfillbox (15, 95, 175, 130, green)
		Font.Draw ("   Cancel", 50, 107, menuFont, white)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    returnClick := 1
		    exit
		end if
	    else
		if settled (x) = userColour (turn) then
		    drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, yellow)
		end if
	    end if
	end for
	exit when returnClick = 1
	View.Update
    end loop
    returnClick := 0
    drawBack
    drawTiles
    for x : 1 .. 54
	if settled (x) not= 999 and settled (x) not= 998 then
	    drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, settled (x))
	end if
    end for
    View.Update
end buildCity

body proc randomTiles
    %Declare variables
    var desert, sheep, brick, ore, wheat, wood := false
    var counter := 1
    var tempRandomizer : int
    %Randomize the numbers for the tiles, excluding any 7s.
    loop
	tempRandomizer := Rand.Int (1, 12)
	for x : 1 .. 19
	    if tempRandomizer = tile (x, 1) then
		tempRandomizer := 999
	    end if
	end for
	if tempRandomizer = 999 then
	else
	    tile (counter, 1) := tempRandomizer
	    counter := counter + 1
	    View.Update
	    if counter = 13 then
		exit
	    end if
	end if
    end loop
    counter := 1
    loop
	%Randomize tile type and make sure that there is one of each type.
	tempRandomizer := Rand.Int (1, 6)
	if desert = true and tempRandomizer = 6 then
	    tempRandomizer := 999
	elsif tempRandomizer = 6 then
	    desert := true
	    robber := counter
	elsif tempRandomizer = 5 then
	    brick := true
	elsif tempRandomizer = 4 then
	    sheep := true
	elsif tempRandomizer = 3 then
	    ore := true
	elsif tempRandomizer = 2 then
	    wheat := true
	elsif tempRandomizer = 1 then
	    wood := true
	end if
	if tempRandomizer = 999 then
	else
	    tile (counter, 2) := tempRandomizer
	    counter := counter + 1
	    View.Update
	    if counter = 20 and desert = true and wood = true and wheat = true and ore = true and sheep = true and brick = true then
		exit
	    elsif counter = 20 then
		counter := 1
		desert := false
		wood := false
		brick := false
		sheep := false
		wheat := false
		ore := false
	    end if
	end if
    end loop
end randomTiles

body proc drawTiles
    %Declare Variables
    var tempColour : int
    %Find each tile type and assign it's colour temporarly
    for x : 1 .. 19
	if tile (x, 2) = 1 then
	    tempColour := 2
	elsif tile (x, 2) = 2 then
	    tempColour := 44
	elsif tile (x, 2) = 3 then
	    tempColour := 247
	elsif tile (x, 2) = 4 then
	    tempColour := 70
	elsif tile (x, 2) = 5 then
	    tempColour := 41
	elsif tile (x, 2) = 6 then
	    tempColour := 91
	end if
	%Draw tile colour,token, then number.
	drawfilloval (typeLocations (x, 1), typeLocations (x, 2), 27, 27, tempColour)
	drawfilloval (typeLocations (x, 1), typeLocations (x, 2), 12, 12, 28)
	if tile (x, 1) = 8 or tile (x, 1) = 6 then
	    Font.Draw (intstr (tile (x, 1)), typeLocations (x, 1) - (Font.Width (intstr (tile (x, 1)), menuFont) div 2), typeLocations (x, 2) - 6, menuFont, red)
	elsif tile (x, 2) not= 6 then
	    Font.Draw (intstr (tile (x, 1)), typeLocations (x, 1) - (Font.Width (intstr (tile (x, 1)), menuFont) div 2), typeLocations (x, 2) - 6, menuFont, black)
	end if
	drawfilloval (typeLocations (robber, 1), typeLocations (robber, 2), 8, 8, black)         %Draw Robber
    end for
end drawTiles

body proc distributeRes
    %Find any tiles with the same number ass the roll. Find the ajacent settlements and assign the resources to those players.
    for x : 1 .. 19
	if tile (x, 1) = roll and tile (x, 1) not= robber then
	    for y : 1 .. 4
		if settled (surrounding (x, 1)) = userColour (y) then
		    if tile (x, 2) = 1 then
			wood (y) := wood (y) + 1
		    elsif tile (x, 2) = 2 then
			wheat (y) := wheat (y) + 1
		    elsif tile (x, 2) = 3 then
			ore (y) := ore (y) + 1
		    elsif tile (x, 2) = 4 then
			sheep (y) := sheep (y) + 1
		    elsif tile (x, 2) = 5 then
			brick (y) := brick (y) + 1
		    end if
		elsif settled (surrounding (x, 1) + 1) = userColour (y) then
		    if tile (x, 2) = 1 then
			wood (y) := wood (y) + 1
		    elsif tile (x, 2) = 2 then
			wheat (y) := wheat (y) + 1
		    elsif tile (x, 2) = 3 then
			ore (y) := ore (y) + 1
		    elsif tile (x, 2) = 4 then
			sheep (y) := sheep (y) + 1
		    elsif tile (x, 2) = 5 then
			brick (y) := brick (y) + 1
		    end if
		elsif settled (surrounding (x, 2)) = userColour (y) then
		    if tile (x, 2) = 1 then
			wood (y) := wood (y) + 1
		    elsif tile (x, 2) = 2 then
			wheat (y) := wheat (y) + 1
		    elsif tile (x, 2) = 3 then
			ore (y) := ore (y) + 1
		    elsif tile (x, 2) = 4 then
			sheep (y) := sheep (y) + 1
		    elsif tile (x, 2) = 5 then
			brick (y) := brick (y) + 1
		    end if
		elsif settled (surrounding (x, 2) + 1) = userColour (y) then
		    if tile (x, 2) = 1 then
			wood (y) := wood (y) + 1
		    elsif tile (x, 2) = 2 then
			wheat (y) := wheat (y) + 1
		    elsif tile (x, 2) = 3 then
			ore (y) := ore (y) + 1
		    elsif tile (x, 2) = 4 then
			sheep (y) := sheep (y) + 1
		    elsif tile (x, 2) = 5 then
			brick (y) := brick (y) + 1
		    end if
		elsif settled (surrounding (x, 3)) = userColour (y) then
		    if tile (x, 2) = 1 then
			wood (y) := wood (y) + 1
		    elsif tile (x, 2) = 2 then
			wheat (y) := wheat (y) + 1
		    elsif tile (x, 2) = 3 then
			ore (y) := ore (y) + 1
		    elsif tile (x, 2) = 4 then
			sheep (y) := sheep (y) + 1
		    elsif tile (x, 2) = 5 then
			brick (y) := brick (y) + 1
		    end if
		elsif settled (surrounding (x, 3) + 1) = userColour (y) then
		    if tile (x, 2) = 1 then
			wood (y) := wood (y) + 1
		    elsif tile (x, 2) = 2 then
			wheat (y) := wheat (y) + 1
		    elsif tile (x, 2) = 3 then
			ore (y) := ore (y) + 1
		    elsif tile (x, 2) = 4 then
			sheep (y) := sheep (y) + 1
		    elsif tile (x, 2) = 5 then
			brick (y) := brick (y) + 1
		    end if
		end if
		for z : 1 .. 16
		    if surrounding (x, 1) = cities (z, 1) then
			if tile (x, 2) = 1 then
			    wood (y) := wood (y) + 1
			elsif tile (x, 2) = 2 then
			    wheat (y) := wheat (y) + 1
			elsif tile (x, 2) = 3 then
			    ore (y) := ore (y) + 1
			elsif tile (x, 2) = 4 then
			    sheep (y) := sheep (y) + 1
			elsif tile (x, 2) = 5 then
			    brick (y) := brick (y) + 1
			end if
		    elsif surrounding (x, 1) + 1 = cities (z, 1) then
			if tile (x, 2) = 1 then
			    wood (y) := wood (y) + 1
			elsif tile (x, 2) = 2 then
			    wheat (y) := wheat (y) + 1
			elsif tile (x, 2) = 3 then
			    ore (y) := ore (y) + 1
			elsif tile (x, 2) = 4 then
			    sheep (y) := sheep (y) + 1
			elsif tile (x, 2) = 5 then
			    brick (y) := brick (y) + 1
			end if
		    elsif surrounding (x, 2) = cities (z, 1) then
			if tile (x, 2) = 1 then
			    wood (y) := wood (y) + 1
			elsif tile (x, 2) = 2 then
			    wheat (y) := wheat (y) + 1
			elsif tile (x, 2) = 3 then
			    ore (y) := ore (y) + 1
			elsif tile (x, 2) = 4 then
			    sheep (y) := sheep (y) + 1
			elsif tile (x, 2) = 5 then
			    brick (y) := brick (y) + 1
			end if
		    elsif surrounding (x, 2) + 1 = cities (z, 1) then
			if tile (x, 2) = 1 then
			    wood (y) := wood (y) + 1
			elsif tile (x, 2) = 2 then
			    wheat (y) := wheat (y) + 1
			elsif tile (x, 2) = 3 then
			    ore (y) := ore (y) + 1
			elsif tile (x, 2) = 4 then
			    sheep (y) := sheep (y) + 1
			elsif tile (x, 2) = 5 then
			    brick (y) := brick (y) + 1
			end if
		    elsif surrounding (x, 3) = cities (z, 1) then
			if tile (x, 2) = 1 then
			    wood (y) := wood (y) + 1
			elsif tile (x, 2) = 2 then
			    wheat (y) := wheat (y) + 1
			elsif tile (x, 2) = 3 then
			    ore (y) := ore (y) + 1
			elsif tile (x, 2) = 4 then
			    sheep (y) := sheep (y) + 1
			elsif tile (x, 2) = 5 then
			    brick (y) := brick (y) + 1
			end if
		    elsif surrounding (x, 3) + 1 = cities (z, 1) then
			if tile (x, 2) = 1 then
			    wood (y) := wood (y) + 1
			elsif tile (x, 2) = 2 then
			    wheat (y) := wheat (y) + 1
			elsif tile (x, 2) = 3 then
			    ore (y) := ore (y) + 1
			elsif tile (x, 2) = 4 then
			    sheep (y) := sheep (y) + 1
			elsif tile (x, 2) = 5 then
			    brick (y) := brick (y) + 1
			end if
		    end if
		end for
	    end for
	end if
    end for
end distributeRes

body proc drawBack
    %Draw background board image, then roads, cities, and settled settlements.
    Pic.Draw (boardBackground, 200, 0, 0)
    for x : 1 .. 60
	if roads (x, 1) not= 999 then
	    Draw.ThickLine (settlements (roads (x, 1), 1), settlements (roads (x, 1), 2), settlements (roads (x, 2), 1), settlements (roads (x, 2), 2), 5, roads (x, 3))
	end if
    end for
    for x : 1 .. 16
	if cities (x, 1) not= 999 then
	    drawfilloval (settlements (cities (x, 1), 1), settlements (cities (x, 1), 2), 10, 10, cities (x, 2) + 2)
	end if
    end for
    for x : 1 .. 54
	if settled (x) not= 999 and settled (x) not= 998 then
	    drawfillbox (settlements (x, 1) - 3, settlements (x, 2) - 3, settlements (x, 1) + 3, settlements (x, 2) + 3, settled (x))
	end if
    end for
end drawBack

body proc gameOver
    %Draw over game and write the victor. Return to main menu after 6 seconds
    drawfillbox (0, 0, 1000, 600, yellow)
    drawfillbox (10, 10, 990, 590, red)
    fontWidth := Font.Width ("Victor!", titleFont)
    Font.Draw ("Victor!", (1000 - fontWidth) div 2, 470, titleFont, white)
    drawfillbox (300, 100, 700, 400, yellow)
    drawfillbox (305, 105, 695, 395, userColour (strint (winner)))
    fontWidth := Font.Width (name (strint (winner)), titleFont)
    Font.Draw (name (strint (winner)), (1000 - fontWidth) div 2, 232, titleFont, userColour (strint (winner)) + 5)
    View.Update
    delay (6000)
    turn := 0
    mainMenu
end gameOver

body proc trade
    %Declare variables.
    var tradeAmount : array 1 .. 5 of int := init (0, 0, 0, 0, 0)
    var mouseX, mouseY, click, partner : int := 0
    var partners : array 1 .. 3 of int := init (0, 0, 0)
    %Draw graphics
    drawfillbox (200, 0, 1000, 600, yellow)
    drawfillbox (210, 10, 990, 590, red)
    drawfillbox (225, 50, 425, 100, yellow)
    drawfillbox (450, 50, 650, 100, yellow)
    drawfillbox (675, 50, 875, 100, yellow)
    drawfillbox (900, 38, 975, 112, yellow)
    drawfillbox (230, 55, 420, 95, red)
    drawfillbox (455, 55, 645, 95, red)
    drawfillbox (680, 55, 870, 95, red)
    drawfillbox (905, 42, 970, 107, red)
    drawfillbox (260, 345, 344, 429, yellow)
    drawfillbox (410, 345, 494, 429, yellow)
    drawfillbox (560, 345, 644, 429, yellow)
    drawfillbox (710, 345, 794, 429, yellow)
    drawfillbox (860, 345, 944, 429, yellow)
    Pic.Draw (woodPic, 265, 350, 0)
    Pic.Draw (brickPic, 415, 350, 0)
    Pic.Draw (wheatPic, 565, 350, 0)
    Pic.Draw (sheepPic, 715, 350, 0)
    Pic.Draw (orePic, 865, 350, 0)
    Font.Draw ("Trade", 520, 510, titleFont, white)
    %Find the amount wanted to trade and then change the amount of resources accordingly
    loop
	%Draw graphics.
	drawfillbox (15, 45, 175, 80, yellow)
	Font.Draw ("Cancel", 65, 57, menuFont, black)
	drawfillbox (260, 440, 344, 460, yellow)
	drawfillbox (410, 440, 494, 460, yellow)
	drawfillbox (560, 440, 644, 460, yellow)
	drawfillbox (710, 440, 794, 460, yellow)
	drawfillbox (860, 440, 944, 460, yellow)
	drawfillbox (260, 335, 344, 315, yellow)
	drawfillbox (410, 335, 494, 315, yellow)
	drawfillbox (560, 335, 644, 315, yellow)
	drawfillbox (710, 335, 794, 315, yellow)
	drawfillbox (860, 335, 944, 315, yellow)
	drawfillbox (260, 175, 344, 259, yellow)
	drawfillbox (410, 175, 494, 259, yellow)
	drawfillbox (560, 175, 644, 259, yellow)
	drawfillbox (710, 175, 794, 259, yellow)
	drawfillbox (860, 175, 944, 259, yellow)
	drawfillbox (265, 180, 339, 254, red)
	drawfillbox (415, 180, 489, 254, red)
	drawfillbox (565, 180, 639, 254, red)
	drawfillbox (715, 180, 789, 254, red)
	drawfillbox (865, 180, 939, 254, red)
	drawfillbox (230, 55, 420, 95, red)
	drawfillbox (455, 55, 645, 95, red)
	drawfillbox (680, 55, 870, 95, red)
	drawfillbox (905, 42, 970, 107, red)
	Draw.ThickLine (915, 70, 935, 49, 4, white)
	Draw.ThickLine (935, 49, 960, 98, 4, white)
	var counter := 0
	for x : 1 .. 4
	    counter := counter + 1
	    if x not= turn then
		fontWidth := Font.Width (name (x), menuFont)
		Font.Draw (name (x), 90 + (228 * counter) - (fontWidth div 2), 70, menuFont, white)
		partners (counter) := x
	    else
		counter := counter - 1
	    end if
	end for
	for x : 1 .. 5
	    fontWidth := Font.Width (intstr (tradeAmount (x)), titleFont)
	    Font.Draw (intstr (tradeAmount (x)), 152 + (150 * x) - (fontWidth div 2), 195, titleFont, white)
	end for
	%Find where mouse is and if it has clicked on a button
	mousewhere (mouseX, mouseY, click)
	if mouseX > 15 and mouseX < 175 and mouseY > 40 and mouseY < 85 then
	    drawfillbox (15, 45, 175, 80, green)
	    Font.Draw ("Cancel", 65, 57, menuFont, white)
	    if click = 1 then
		loop
		    mousewhere (mouseX, mouseY, click)
		    exit when click = 0
		end loop
		returnClick := 1
		exit
	    end if
	end if
	if mouseY > 440 and mouseY < 460 then
	    if mouseX > 260 and mouseX < 344 then
		drawfillbox (265, 445, 339, 455, green)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    tradeAmount (1) := tradeAmount (1) + 1
		end if
	    elsif mouseX > 410 and mouseX < 494 then
		drawfillbox (415, 445, 489, 455, green)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    tradeAmount (2) := tradeAmount (2) + 1
		end if
	    elsif mouseX > 560 and mouseX < 644 then
		drawfillbox (565, 445, 639, 455, green)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    tradeAmount (3) := tradeAmount (3) + 1
		end if
	    elsif mouseX > 710 and mouseX < 794 then
		drawfillbox (715, 445, 789, 455, green)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    tradeAmount (4) := tradeAmount (4) + 1
		end if
	    elsif mouseX > 860 and mouseX < 944 then
		drawfillbox (865, 445, 939, 455, green)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    tradeAmount (5) := tradeAmount (5) + 1
		end if
	    end if
	elsif mouseY > 315 and mouseY < 335 then
	    if mouseX > 260 and mouseX < 344 then
		drawfillbox (265, 320, 339, 330, red)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    tradeAmount (1) := tradeAmount (1) - 1
		end if
	    elsif mouseX > 410 and mouseX < 494 then
		drawfillbox (415, 320, 489, 330, red)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    tradeAmount (2) := tradeAmount (2) - 1
		end if
	    elsif mouseX > 560 and mouseX < 644 then
		drawfillbox (565, 320, 639, 330, red)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    tradeAmount (3) := tradeAmount (3) - 1
		end if
	    elsif mouseX > 710 and mouseX < 794 then
		drawfillbox (715, 320, 789, 330, red)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    tradeAmount (4) := tradeAmount (4) - 1
		end if
	    elsif mouseX > 860 and mouseX < 944 then
		drawfillbox (865, 320, 939, 330, red)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    tradeAmount (5) := tradeAmount (5) - 1
		end if
	    end if
	elsif mouseY > 50 and mouseY < 100 then
	    if mouseX > 225 and mouseX < 425 then
		drawfillbox (230, 55, 420, 95, green)
		fontWidth := Font.Width (name (partners (1)), menuFont)
		Font.Draw (name (partners (1)), 90 + (228 * 1) - (fontWidth div 2), 70, menuFont, white)
		if click = 1 then
		    partner := partners (1)
		end if
	    elsif mouseX > 450 and mouseX < 650 then
		drawfillbox (455, 55, 645, 95, green)
		fontWidth := Font.Width (name (partners (2)), menuFont)
		Font.Draw (name (partners (2)), 90 + (228 * 2) - (fontWidth div 2), 70, menuFont, white)
		if click = 1 then
		    partner := partners (2)
		end if
	    elsif mouseX > 675 and mouseX < 875 then
		drawfillbox (680, 55, 870, 95, green)
		fontWidth := Font.Width (name (partners (3)), menuFont)
		Font.Draw (name (partners (3)), 90 + (228 * 3) - (fontWidth div 2), 70, menuFont, white)
		if click = 1 then
		    loop
			mousewhere (mouseX, mouseY, click)
			exit when click = 0
		    end loop
		    partner := partners (3)
		end if
	    end if
	end if
	if mouseX > 900 and mouseX < 975 and mouseY > 38 and mouseY < 112 then
	    drawfillbox (905, 42, 970, 107, green)
	    Draw.ThickLine (915, 70, 935, 49, 4, white)
	    Draw.ThickLine (935, 49, 960, 98, 4, white)
	    if click = 1 then
		loop
		    mousewhere (mouseX, mouseY, click)
		    exit when click = 0
		end loop
		%Check if each player has enough resources. If so, subtract from each the amount indicated.
		if partner not= 0 and wood (partner) >= tradeAmount (1) and brick (partner) >= tradeAmount (2) and wheat (partner) >= tradeAmount (3) and sheep (partner) >= tradeAmount (4) and 
		    ore (partner) >=
			tradeAmount (5) then
		    if wood (turn) >= (0 - tradeAmount (1)) and brick (turn) >= (0 - tradeAmount (2)) and wheat (turn) >= (0 - tradeAmount (3)) and sheep (turn) >= (0 - tradeAmount (4)) and
			    ore (turn) >= (0 - tradeAmount (5)) then
			wood (partner) := wood (partner) - tradeAmount (1)
			brick (partner) := brick (partner) - tradeAmount (2)
			wheat (partner) := wheat (partner) - tradeAmount (3)
			sheep (partner) := sheep (partner) - tradeAmount (4)
			ore (partner) := ore (partner) - tradeAmount (5)
			wood (turn) := wood (turn) - (0 - tradeAmount (1))
			brick (turn) := brick (turn) - (0 - tradeAmount (2))
			wheat (turn) := wheat (turn) - (0 - tradeAmount (3))
			sheep (turn) := sheep (turn) - (0 - tradeAmount (4))
			ore (turn) := ore (turn) - (0 - tradeAmount (5))
			returnClick := 1
			exit
		    end if
		end if
	    end if
	end if
	%Keep button selected once clicked
	if partner not= 0 then
	    if partner = partners (1) then
		drawfillbox (230, 55, 420, 95, green)
		fontWidth := Font.Width (name (partners (1)), menuFont)
		Font.Draw (name (partners (1)), 90 + (228 * 1) - (fontWidth div 2), 70, menuFont, white)
	    elsif partner = partners (2) then
		drawfillbox (455, 55, 645, 95, green)
		fontWidth := Font.Width (name (partners (2)), menuFont)
		Font.Draw (name (partners (2)), 90 + (228 * 2) - (fontWidth div 2), 70, menuFont, white)
	    elsif partner = partners (3) then
		drawfillbox (680, 55, 870, 95, green)
		fontWidth := Font.Width (name (partners (3)), menuFont)
		Font.Draw (name (partners (3)), 90 + (228 * 3) - (fontWidth div 2), 70, menuFont, white)
	    end if
	end if
	View.Update
	exit when returnClick = 1
    end loop
    returnClick := 0
    %Redraw info and graphics
    drawBack
    drawTiles
    updateRes
end trade

body proc exitProgram
    %End music and close program
    Music.PlayFileStop
    GUI.CloseWindow (bgWindow)
    GUI.CloseWindow (mainWindow)
    GUI.Quit
end exitProgram

%MAIN
fork music
introAnimation
%setup
%GUI process loop
loop
    exit when GUI.ProcessEvent
end loop
