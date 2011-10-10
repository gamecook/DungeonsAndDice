/*
 * Copyright (c) 2011 Jesse Freeman
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


package com.gamecook.dungeonsanddice.activities
{
    import com.gamecook.dungeonsanddice.utils.DicePokerValidationUtil;
    import com.gamecook.dungeonsanddice.utils.DicePokerValidationUtil;
    import com.gamecook.dungeonsanddice.views.DiceView;
    import com.gamecook.dungeonsanddice.views.DiceView;
    import com.gamecook.dungeonsanddice.views.DiceView;
    import com.gamecook.dungeonsanddice.views.DiceView;
    import com.gamecook.dungeonsanddice.views.DiceView;
    import com.gamecook.frogue.enum.SlotsEnum;
    import com.gamecook.frogue.equipment.IEquipable;
    import com.gamecook.frogue.sprites.SpriteSheet;
    import com.gamecook.frogue.tiles.MonsterTile;
    import com.gamecook.frogue.tiles.TileTypes;
    import com.gamecook.dungeonsanddice.enums.DifficultyLevels;
    import com.gamecook.dungeonsanddice.factories.SpriteFactory;
    import com.gamecook.dungeonsanddice.factories.SpriteSheetFactory;
    import com.gamecook.dungeonsanddice.factories.TextFieldFactory;
    import com.gamecook.dungeonsanddice.sounds.MHSoundClasses;
    import com.gamecook.dungeonsanddice.utils.ArrayUtil;
    import com.gamecook.dungeonsanddice.views.CharacterView;
    import com.gamecook.dungeonsanddice.views.IMenuOptions;
    import com.gamecook.dungeonsanddice.views.MenuBar;
    import com.gamecook.dungeonsanddice.views.StatusBarView;
    import com.jessefreeman.factivity.activities.IActivityManager;
    import com.jessefreeman.factivity.managers.SingletonManager;
    import com.jessefreeman.factivity.threads.effects.Quake;
    import com.jessefreeman.factivity.threads.effects.TypeTextEffect;
    import com.jessefreeman.factivity.utils.DeviceUtil;

    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BitmapFilterQuality;
    import flash.filters.GlowFilter;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    import flashx.textLayout.formats.TextAlign;

    import uk.co.soulwire.display.PaperSprite;

    /**
     *
     * This class represents the core logic for the game.
     *
     */
    public class GameActivity extends LogoActivity implements IMenuOptions
    {

        [Embed(source="../../../../../build/assets/dice_spritesheet.png")]
        private var DiceSpriteSheet:Class;

        [Embed(source="../../../../../build/assets/game_board.png")]
        private var GameBoardImage:Class;

        [Embed(source="../../../../../build/assets/tile_highlight.png")]
        private var TileHighlightImage:Class;

        private var flipping:Boolean;
        private var activeTiles:Array = [];
        private var maxActiveTiles:int = 1;
        private var tileContainer:Sprite;
        private var player:CharacterView;
        private var monster:CharacterView;
        private var difficulty:int;
        private var statusBar:StatusBarView;
        private var bonus:int = 0;
        private var quakeEffect:Quake;
        private var textEffect:TypeTextEffect;
        private var bonusLabel:TextField;
        private var gameBackground:Bitmap;
        private var highlightInstances:Array = [];
        private var debug:Boolean = false;
        private var monsterCounter:int = 0;
        private var monsterAttackDelay:int = 15000;
        private var attackWarningLabel:TextField;
        private var playerDiceInstances:Array = [];
        private var monsterDiceInstances:Array = [];
        private var diceSpriteSheet:SpriteSheet;
        private var playerDiceContainer:Sprite;
        private var monsterDiceContainer:Sprite;
        private var round:int = 0;
        private var maxRounds:int = 2;
        private var characterGroup:Sprite;

        public function GameActivity(activityManager:IActivityManager, data:*)
        {
            super(activityManager, data);
        }


        override protected function onCreate():void
        {

            // Have the soundManager play the background theme song
            soundManager.playMusic(MHSoundClasses.DungeonLooper);

            super.onCreate();

            displayContextualButton("EXIT");

            // Set the difficulty level from the active state object
            difficulty = activeState.difficulty;
        }


        override protected function onContextualButtonClick(event:MouseEvent):void
        {
            nextActivity(StartActivity);
        }

        override public function onStart():void
        {
            super.onStart();

            createDiceSpriteSheet();

            var menuBar:MenuBar = addChild(new MenuBar(MenuBar.EXIT_ONLY_MODE, logo.width, this)) as MenuBar;
            /*menuBar.x = logo.x;
            menuBar.y = logo.y + logo.height - 2;*/

            activeState.initialScore = activeState.score;

            tileContainer = addChild(new Sprite()) as Sprite;
            tileContainer.x = HUD_WIDTH;
            tileContainer.y = 33;

            gameBackground = tileContainer.addChild(Bitmap(new GameBoardImage())) as Bitmap;

            var total:int = 10;


            characterGroup = tileContainer.addChild(new Sprite()) as Sprite;


            /*var i:int;
            var tile:PaperSprite;

            var sprites:Array = SpriteFactory.createSprites(6);

            // Add Potions
            if (int(Math.random() * (difficulty)) == 0)
                sprites.splice(0, 1, "P");

            // Add Gold
            if (int(Math.random() * (difficulty + 2)) == 0)
                sprites.splice(1, 1, "$");

            // Add Treasure
            if (int(Math.random() * (difficulty + 4)) == 0)
                sprites.splice(2, 1, "T");

            var typeIndex:int = -1;
            var typeCount:int = 2;
            var tileBitmap:Bitmap;
            */
            statusBar = addChild(new StatusBarView()) as StatusBarView;
            statusBar.x = (fullSizeWidth - statusBar.width) * .5;
            statusBar.y = menuBar.y + 8;
            var spriteName:String;

            activeState.levelTurns = 0;

            createPlayer(total);

            var monsterModel:MonsterTile = new MonsterTile();
            monsterModel.parseObject({name:"monster", maxLife: total / 2});

            monster = characterGroup.addChild(new CharacterView(monsterModel)) as CharacterView;
            monster.x = player.width + 12;
            monster.generateRandomEquipment();

            attackWarningLabel = monster.addChild(TextFieldFactory.createTextField(TextFieldFactory.textFormatLargeCenter, "", 20)) as TextField;
            attackWarningLabel.x = -32;
            attackWarningLabel.y = 10;

            var outline:GlowFilter = new GlowFilter();
            outline.blurX = outline.blurY = 2;
            outline.color = 0x000000;
            outline.quality = BitmapFilterQuality.HIGH;
            outline.strength = 100;

            var filterArray:Array = new Array();
            filterArray.push(outline);
            attackWarningLabel.filters = filterArray;

            if (DeviceUtil.os != DeviceUtil.IOS)
            {
                quakeEffect = new Quake(null);
                textEffect = new TypeTextEffect(statusBar.message, onTextEffectUpdate);
            }
            createBonusLabel();

            updateStatusBar();

            // Update status message
            updateStatusMessage("You have entered level " + activeState.playerLevel + " of the dungeon.\nClick to roll your first attack.");

            // Setup monster timer
            if (difficulty == 1)
            {
                monsterAttackDelay = -1
            }
            else if (difficulty == 2)
            {
                monsterCounter = monsterAttackDelay;
            }
            else
            {
                monsterCounter = monsterAttackDelay;
            }

            createPlayerDice();
            createMonsterDice();

            addChild(menuBar);

            tileContainer.addEventListener(MouseEvent.CLICK, onClick);

            characterGroup.x = ((tileContainer.width - characterGroup.width) * .5);
            characterGroup.y = (tileContainer.height - characterGroup.height) * .5;

        }

        private function createDiceSpriteSheet():void
        {
            diceSpriteSheet = new SpriteSheet();
            var tileSize:int = 40;
            var bitmap:Bitmap = new DiceSpriteSheet();
            diceSpriteSheet.bitmapData = bitmap.bitmapData;
            var i:int;
            var total:int = Math.floor(bitmap.width / tileSize);
            var spriteRect:Rectangle = new Rectangle(0, 0, tileSize, tileSize);
            for (i = 0; i < total; ++i)
            {
                spriteRect.x = i * tileSize;
                diceSpriteSheet.registerSprite("sprite" + i, spriteRect.clone());
            }
        }

        private function createPlayerDice():void
        {
            playerDiceContainer = addChild(new Sprite()) as Sprite;
            createDiceGroup(playerDiceContainer, playerDiceInstances);
            playerDiceContainer.x = ((BACKGROUND_WIDTH - playerDiceContainer.width) * .5) + HUD_WIDTH;
            playerDiceContainer.y =fullSizeHeight - playerDiceContainer.height - 2;
        }

        private function createMonsterDice():void
        {
            monsterDiceContainer = addChild(new Sprite()) as Sprite;
            createDiceGroup(monsterDiceContainer, monsterDiceInstances);
            monsterDiceContainer.scaleX = monsterDiceContainer.scaleY = .5;
            monsterDiceContainer.x = HUD_WIDTH + 42;
            monsterDiceContainer.y = 13;
        }

        private function createDiceGroup(container:Sprite, instanceCollection:Array):void
        {
            var total:int = 5;
            var i:int;
            var dice:DiceView;
            var padding:int = 4;
            for (i = 0; i < total; i++)
            {
                dice = container.addChild(new DiceView(diceSpriteSheet)) as DiceView;
                dice.x = (dice.width+padding) * i;

                instanceCollection.push(dice);
            }
        }

        private function rollDice(collection:Array):void
        {
            var total:int = collection.length;
            var i:int;
            var dice:DiceView;

            for(i = 0; i < total; i++)
            {
                dice = collection[i]
                if(!dice.selected)
                    dice.roll();
            }
        }

        private function createPlayer(total:int):void
        {
            var maxLife:int = (total / difficulty) + 5;

            var playerModel:MonsterTile = new MonsterTile();

            playerModel.parseObject({name:"player", maxLife: maxLife, life:activeState.playerLife > 0 ? activeState.playerLife : maxLife});

            var sprites:Array = [TileTypes.getTileSprite("@")];

            if (activeState.equippedInventory[SlotsEnum.ARMOR])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.ARMOR]));

            if (activeState.equippedInventory[SlotsEnum.HELMET])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.HELMET]));

            if (activeState.equippedInventory[SlotsEnum.BOOTS])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.BOOTS]));

            if (activeState.equippedInventory[SlotsEnum.SHIELD])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.SHIELD]));

            if (activeState.equippedInventory[SlotsEnum.WEAPON])
                sprites.push(TileTypes.getTileSprite(activeState.equippedInventory[SlotsEnum.WEAPON]));

            player = characterGroup.addChild(new CharacterView(playerModel, sprites)) as CharacterView;
        }

        private function createBonusLabel():void
        {
            var textFormatLarge:TextFormat = new TextFormat("system", 16, 0xffffff);
            textFormatLarge.align = TextAlign.CENTER;

            bonusLabel = addChild(new TextField()) as TextField;
            bonusLabel.defaultTextFormat = textFormatLarge;
            bonusLabel.text = "Bonus x3";
            bonusLabel.embedFonts = true;
            bonusLabel.selectable = false;
            bonusLabel.autoSize = TextFieldAutoSize.LEFT;
            bonusLabel.background = true;
            bonusLabel.backgroundColor = 0x000000;
            bonusLabel.visible = false;

            bonusLabel.x = (fullSizeWidth - bonusLabel.width) * .5;
            bonusLabel.y = gameBackground.y + gameBackground.height - (bonusLabel.height + 2);
        }

        private function onTextEffectUpdate():void
        {
            //soundManager.play(MHSoundClasses.TypeSound);
        }

        private function updateStatusBar():void
        {
            statusBar.setScore(activeState.score);
            statusBar.setLevel(activeState.playerLevel, "<span class='lightGray'>-"+DifficultyLevels.getLabel(difficulty).substr(0,1).toUpperCase())+"</span>";
            statusBar.setTurns(activeState.levelTurns);
        }

        /**
         *
         * Handle click event from Tile.
         *
         * @param event
         */
        private function onClick(event:MouseEvent):void
        {
            // Clear status message
            statusBar.setMessage("");

            resetMonsterAttackCounter();

            if(round < maxRounds)
            {
                rollDice(playerDiceInstances);
                rollDice(monsterDiceInstances);
                var rank1 : Object = DicePokerValidationUtil.rankHand(getDiceValues(playerDiceInstances));
                var rank2 : Object = DicePokerValidationUtil.rankHand(getDiceValues(monsterDiceInstances));

                updateStatusMessage("Round "+(round+1)+": Player 1 has "+rank1.type+" ("+rank1.rank+")\n Monster has " +rank2.type+" ("+rank2.rank+")");
                round++;
            }
            else
            {
                var rank1 : Object = DicePokerValidationUtil.rankHand(getDiceValues(playerDiceInstances));
                var rank2 : Object = DicePokerValidationUtil.rankHand(getDiceValues(monsterDiceInstances));

                resetRound();

                if(rank1.rank > rank2.rank)
                {

                    increaseBonus();
                    attack(player, monster, rank1.typeID);
                }
                else
                {
                    resetBonus();
                    attack(monster, player, rank2.typeID);
                }

                if (monster.isDead)
                    onMonsterDead();
                else if(player.isDead)
                    onPlayerDead();


            }
            // Test to see if a tile is flipping
            /*if (!flipping)
            {
                // Play flip sound
                soundManager.play(MHSoundClasses.WallHit);

                // Get instance of the currently selected PaperSprite
                var target:PaperSprite = event.target as PaperSprite;

                // If this tile is already active exit the method
                if ((activeTiles.indexOf(target) != -1) || player.isDead)
                    return;

                // push the tile into the active tile array
                activeTiles.push(target);

                var highlight:Bitmap = highlightInstances[activeTiles.length - 1];
                highlight.visible = true;
                highlight.x = target.x - (target.width * .5) + 1;
                highlight.y = target.y - (target.height * .5) + 1;

                // Check if the debug mode is on, we need to do handle this differently.
                if (!debug)
                {

                    // We are about to flip the tile. Add a complete event listener so we know when it's done.
                    target.addEventListener(Event.COMPLETE, onFlipComplete);

                    // Flip the tile
                    target.flip();

                    // Set the flipping flag.
                    flipping = true;
                }
                else
                {
                    // If difficulty was set to 1 (easy) there is no flip so manually call endTurn.
                    endTurn();
                }

            }*/

        }

        private function resetRound():void
        {
            round = 0;
            //TODO this should be a constant and not rely on the player/monster dice arrays tobe the same.
            var total:int = playerDiceInstances.length;
            var i:int;
            for (i =0; i<total; i++)
            {
                DiceView(playerDiceInstances[i]).reset();
                DiceView(monsterDiceInstances[i]).reset();
            }
        }

        private function getDiceValues(collection:Array):Array
        {
            var values:Array = [];

            var total:int = collection.length;
            var i:int;

            for (i = 0; i < total; i++)
            {
                values.push(DiceView(collection[i]).value);
            }

            return values;

        }

        /**
         *
         * Called when a tile's Flip is completed.
         *
         * @param event
         *
         */
        private function onFlipComplete(event:Event):void
        {

            // Get the tile that recently flipped
            var target:PaperSprite = event.target as PaperSprite;

            // Remove the event listener
            target.removeEventListener(Event.COMPLETE, onFlipComplete);

            // Set the flipping flag to false
            flipping = false;

            // End the turn.
            endTurn();
        }

        /**
         *
         * This validates if we have reached the total number of active tiles. If so we need to check for matches and
         * handle any related game logic.
         *
         */
        private function endTurn():void
        {

            // See if we have active the maximum active tiles allowed.
            if (activeTiles.length > maxActiveTiles)
            {
                // Validate any matches
                findMatches();

                // Reset any tiles that do not match
                resetActiveTiles();

                // Increment our turns counter in the activeState object
                activeState.levelTurns ++;
                activeState.increaseTotalTurns();
            }

        }

        /**
         *
         * This method goes through all of the Active tiles and tries to identify any matches.
         *
         */
        private function findMatches():void
        {

            var i:int, j:int;
            var total:int = activeTiles.length;
            var currentTile:PaperSprite;
            var testTile:PaperSprite;
            var tileName:String;
            var match:Boolean;

            // Loop through active tiles and compare each item to the rest of the tiles in the array.
            for (i = 0; i < total; i++)
            {
                // save an instance of the current tile to test with
                currentTile = activeTiles[i];
                tileName = currentTile.name;
                // Reloop through all the items starting back at the beginning
                for (j = 0; j < total; j++)
                {
                    // select the item to test against
                    testTile = activeTiles[j];
                    // Make sure we aren't testing the same item
                    if ((currentTile != testTile) && (currentTile.name == testTile.name))
                    {
                        // A match has been found so make sure the current tile and test tile are set to invisible.
                        currentTile.visible = false;
                        testTile.visible = false;

                        // Flag that a match has been found.
                        match = true;

                    }
                }

                if (highlightInstances[i])
                    highlightInstances[i].visible = false;
            }

            // Validate match
            if (match)
            {
                onMatch(tileName);
            }
            else
            {
                // Update status message
                updateStatusMessage("You did not find a match.\nYou lose 1 HP from the monster's attack.");
                onNoMatch();
            }

        }

        /**
         *
         * Loops through any active tiles and flips them. This only calls flip for any difficulty level higher then 1 (easy)
         *
         */
        private function resetActiveTiles():void
        {
            // Loop through all tiles
            for each (var tile:PaperSprite in activeTiles)
            {
                // Make sure the difficulty is higher then easy
                if (!debug)
                    tile.flip();
            }

            // Clear the activeTiles array when we are done.
            activeTiles.length = 0;
        }

        /**
         *
         * Called when no match is found.
         *
         */
        private function onNoMatch():void
        {
            if (quakeEffect)
            {
                quakeEffect.target = player;
                addThread(quakeEffect);
            }

            // Reset bonus flag
            resetBonus();

            // Take away 1 HP from the player
            player.subtractLife(1);

            // Play attack sound
            soundManager.play(MHSoundClasses.EnemyAttack);

            // Update status before testing if the player is dead
            updateStatusBar();

            resetMonsterAttackCounter();
            // Test to see if the player is dead
            if (player.isDead)
                onPlayerDead();
        }

        private function resetMonsterAttackCounter():void
        {
            // Reset monster attack counter
            monsterCounter = monsterAttackDelay;
        }

        private function resetBonus():void
        {
            bonus = 0;
            bonusLabel.visible = false;
        }

        /**
         *
         * Called when a match is found.
         *
         */
        private function onMatch(type:String):void
        {
            trace("Matched", type, type.substr(0, 1));

            switch (type.substr(0, 1))
            {
                case "P":
                    updateStatusMessage("Player drinks potion and restores " + (player.getMaxLife() - player.getLife()));
                    trace("Found Potion");
                    player.addLife(player.getMaxLife());
                    increaseBonus();
                    break

                case "W":
                    trace("Found Weapon");
                    //playerAttack();
                    break;

                case "S":
                case "H":
                case "A":
                case "B":
                    trace("Found Armor");
                    //playerAttack();
                    break;

                case "$":
                    trace("Found Money");

                    increaseBonus();
                    break;

                case "T":
                    trace("Found Treasure");
                    increaseBonus();
                    break;


            }

            //playerAttack();

            // Reset monster attack counter
            monsterCounter = monsterAttackDelay;
        }

        private function attack(attacker:CharacterView, target:CharacterView, bonus:int = 1):void
        {
            if (quakeEffect)
            {
                quakeEffect.target = target;
                addThread(quakeEffect);
            }

            // Increase bonus flag
            increaseBonus();

            // Take away 1 HP from the monster
            if(bonus <= 0)
                bonus = 1;

            target.subtractLife(1+bonus);

            // Play attack sound
            soundManager.play(MHSoundClasses.PotionSound);

            // Update status message
            updateStatusMessage(attacker.name+" hits "+target.name+" for "+(1+bonus)+"HP points with a "+DicePokerValidationUtil.getType(bonus));

            trace("Attack Message", attacker.name+" hits "+target.name+" for "+(1+bonus)+"HP points with a "+DicePokerValidationUtil.getType(bonus));

            activeState.score += 1 + bonus;

            // Update status before testing for monster being dead
            updateStatusBar();

        }

        private function displayBonusMessage(value:String):void
        {
            bonusLabel.text = value;
            bonusLabel.x = (fullSizeWidth - bonusLabel.width) * .5;

            if (bonus > 0)
                bonusLabel.visible = true;
        }

        private function increaseBonus():void
        {
            bonus ++;
            activeState.bestBonus = bonus;

            if (bonus > 0)
                displayBonusMessage("Bonus x" + bonus);
        }

        /**
         *
         * Called when the player is dead.
         *
         */
        private function onPlayerDead():void
        {
            if (quakeEffect)
            {
                removeThread(quakeEffect)
            }

            // Update status message
            updateStatusMessage("You have been defeated!");

            // Flip over the player's tile to show the blood
            player.flip();

            // Kill all sounds, including the BG music.
            soundManager.destroySounds(true);

            // Play death sound
            soundManager.play(MHSoundClasses.DeathTheme);

            // Clear the activeGame so player can't exit and try again.
            activeState.activeGame = false;

            // Show the game over activity after 2 seconds
            startNextActivityTimer(LoseActivity, 2, {characterImage: monster.getImage()});
        }

        /**
         *
         * Called when the monster is dead.
         *
         */
        private function onMonsterDead():void
        {
            if (quakeEffect)
            {
                removeThread(quakeEffect)
            }

            //Save State
            activeState.playerLife = player.getLife();

            // Update status message
            updateStatusMessage("You have defeated the monster.");

            // Flip over the monster's tile to show the blood.
            monster.flip();

            // Kill all sounds, including the BG music.
            soundManager.destroySounds(true);

            // Play win sound
            soundManager.play(MHSoundClasses.WinBattle);

            var equipment:IEquipable;
            var rand:int = Math.random() * 6;

            var droppedEquipment:IEquipable

            switch (rand)
            {
                case SlotsEnum.ARMOR:
                    droppedEquipment = monster.getArmorSlot();
                    break;
                case SlotsEnum.WEAPON:
                    droppedEquipment = monster.getWeaponSlot();
                    break;
                case SlotsEnum.SHIELD:
                    droppedEquipment = monster.getShieldSlot();
                    break;
                case SlotsEnum.HELMET:
                    droppedEquipment = monster.getHelmetSlot();
                    break;
                case SlotsEnum.BOOTS:
                    droppedEquipment = monster.getHelmetSlot();
                    break;
            }

            // Show the game over activity after 2 seconds
            startNextActivityTimer(WinActivity, 2, {characterImage: player.getImage(), droppedEquipment: droppedEquipment});
        }

        public function updateStatusMessage(value:String):void
        {
            value = "<span class='orange'>"+value+"</span>";

            if (value.length > 0)
            {
                if (textEffect)
                {
                    textEffect.newMessage(value, 2);
                    addThread(textEffect);
                    value = "";
                }
                else
                {
                    statusBar.message.text = value;
                }
            }
            else
            {
                statusBar.message.text = value;
            }
        }


        override public function onBack():void
        {
            super.onBack();
            nextActivity(StartActivity);
        }

        override public function update(elapsed:Number = 0):void
        {

            super.update(elapsed);

            if (monsterAttackDelay != -1)
            {
                if (monsterCounter <= 0)
                    onNoMatch();
                else
                {
                    monsterCounter -= elapsed;
                    if (monsterCounter <= 5500)
                    {
                        var timeLeft:int = Math.round(monsterCounter / 1000)

                        if (timeLeft < 4)
                        {
                            attackWarningLabel.textColor = 0xff0000;
                        }
                        else
                        {
                            attackWarningLabel.textColor = 0xffffff;
                        }

                        attackWarningLabel.text = timeLeft == 0 ? "!!" : timeLeft.toString();
                    }
                    else
                    {
                        attackWarningLabel.text = "";
                    }
                }
            }
        }

        public function onExit():void
        {
            onBack();
        }

        public function onInventory():void
        {

        }

        public function onPause()
        {

        }
    }
}
