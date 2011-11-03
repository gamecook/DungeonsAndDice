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

package com.gamecook.dungeonsanddice.states
{
    import com.jessefreeman.factivity.state.AbstractStateObject;

    public class ActiveGameState extends AbstractStateObject
    {
        private const GAME_NAME:String = "dungeonsanddice";

        public function ActiveGameState()
        {
            super(this, GAME_NAME);
        }

        public function get activeGame():Boolean
        {
            return _dataObject.activeGame;
        }

        public function set activeGame(value:Boolean):void
        {
            _dataObject.activeGame = value;
        }

        public function get playerLevel():int
        {
            return _dataObject.playerLevel;
        }

        public function set playerLevel(value:int):void
        {
            _dataObject.playerLevel = value;
        }

        public function get playerLife():int
        {
            return _dataObject.playerLife;
        }

        public function set playerLife(value:int):void
        {
            _dataObject.playerLife = value;
        }

        public function get mute():Boolean
        {
            return _dataObject.hasOwnProperty("mute") ? _dataObject.mute : false;
        }

        public function get difficulty():int
        {
            return _dataObject.difficulty ? _dataObject.difficulty : 1;
        }

        public function set difficulty(value:int):void
        {
            _dataObject.difficulty = value;
        }

        public function get score():int
        {
            return _dataObject.score;
        }

        public function set score(value:int):void
        {
            _dataObject.score = value;
        }

        public function get levelTurns():int
        {
            return _dataObject.levelTurns;
        }

        public function set levelTurns(value:int):void
        {
            _dataObject.levelTurns = value;
        }

        public function set bestBonus(value:int):void
        {
            if (value > _dataObject.bestBonus)
                _dataObject.bestBonus = value;
        }

        public function get bestBonus():int
        {
            return _dataObject.bestBonus;
        }

        public function unlockEquipment(tileID:String):void
        {
            if (!_dataObject.unlockedEquipment)
                _dataObject.unlockedEquipment = [tileID];
            else
            {
                if (_dataObject.unlockedEquipment.indexOf(tileID) == -1)
                {
                    _dataObject.unlockedEquipment.push(tileID);
                }
            }
        }

        public function getUnlockedEquipment():Array
        {
            if (!_dataObject.unlockedEquipment)
                _dataObject.unlockedEquipment = [];

            return _dataObject.unlockedEquipment;
        }

        public function addCoin(coinID:String):void
        {
            if (!_dataObject.coins)
            {
                _dataObject.coins = [];
            }

            if (!_dataObject.coins[coinID])
                _dataObject.coins[coinID] = 1;
            else
                _dataObject.coins[coinID] ++;
        }

        public function getCoins():Array
        {
            if (!_dataObject.coins)
                _dataObject.coins = [];

            return _dataObject.coins;
        }

        public function set mute(muteValue:Boolean):void
        {
            _dataObject.mute = muteValue;
        }

        public function reset():void
        {
            // Restore default values
            _dataObject.bestBonus = 0;
            _dataObject.playerLife = 0;
            _dataObject.levelTurns = 0;
            _dataObject.score = 0;
            _dataObject.turns = 0;
            _dataObject.playerLevel = 0;
            _dataObject.activeGame = false;
            _dataObject.totalKills = 0;
        }

        public function get equippedInventory():Array
        {
            if (!_dataObject.equippedInventory)
                _dataObject.equippedInventory = [];

            return _dataObject.equippedInventory;
        }

        public function get totalWins():String
        {
            if (!_dataObject.totalWins)
                _dataObject.totalWins = 0;

            return _dataObject.totalWins;
        }

        public function increaseTotalWins():String
        {
            if (!_dataObject.totalWins)
                _dataObject.totalWins = 0;
            return _dataObject.totalWins ++;
        }

        public function get totalLosses():String
        {
            if (!_dataObject.totalLosses)
                _dataObject.totalLosses = 0;

            return _dataObject.totalLosses;
        }

        public function increaseTotalLosses():String
        {
            if (!_dataObject.totalLosses)
                _dataObject.totalLosses = 0;
            return _dataObject.totalLosses ++;
        }

        public function get totalTurns():String
        {
            if (!_dataObject.totalTurns)
                _dataObject.totalTurns = 0;

            return _dataObject.totalTurns;
        }

        public function increaseTotalTurns():String
        {
            if (!_dataObject.totalTurns)
                _dataObject.totalTurns = 0;
            return _dataObject.totalTurns ++;
        }

        public function set initialScore(value:int):void
        {
            _dataObject.initialScore = value;
        }

        public function get initialScore():int
        {
            return _dataObject.initialScore;
        }

        public function get totalKills():int
        {
            return _dataObject.totalKills;
        }

        public function increaseTotalKills():String
        {
            if (!_dataObject.totalKills)
                _dataObject.totalTurns = 0;
            return _dataObject.totalKills ++;
        }

        public function get playerName():String
        {
            return _dataObject.playerName;
        }

        public function set playerName(value:String):void
        {
            _dataObject.playerName = value;
        }

        public function get playerClass():String
        {
            return _dataObject.playerClass;
        }

        public function set playerClass(value:String):void
        {
            _dataObject.playerClass = value;
        }
    }
}
