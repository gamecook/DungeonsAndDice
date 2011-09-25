package {    import com.gamecook.dungeonsanddice.utils.DicePokerValidationUtil;    import flash.display.Sprite;	public class DicePokerApp extends Sprite {		public function DicePokerApp() {						var types : Array = new Array("High Card", "One Pair", "Two Pair", "Three of a Kind", "Full House", "Straight", "Four of a Kind", "Five of a Kind");			for (var run : Number = 0;run < 5; run++) {				trace("Test " + run);				var hand1 : Array = makeRandomHand();				var hand2 : Array = makeRandomHand();				var rank1 : Object = DicePokerValidationUtil.rankHand(hand1);				var rank2 : Object = DicePokerValidationUtil.rankHand(hand2);				trace("Hand 1: " + hand1 + " has value: " + rank1.rank + ", and is a " + types[rank1.typeID]);				trace("Hand 2: " + hand2 + " has value: " + rank2.rank + ", and is a " + types[rank2.typeID]);				var winner : Number = DicePokerValidationUtil.compareHands(hand1, hand2);				trace("Winner is hand" + winner);			}		}		private function makeRandomHand() : Array {			var hand : Array = new Array(diceRoll(), diceRoll(), diceRoll(), diceRoll(), diceRoll());			return hand;		}		private function diceRoll() : int {			return ((Math.random() * 1000) % 6) + 1;		}	}}