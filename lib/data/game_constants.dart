import 'package:flutter/material.dart';

class GameConstants {
  static const int minPlayers = 2;
  static const int maxPlayers = 6;
  static const int maxDestiny = 20;
  static const int maxStory = 20;

  static const List<String> wealthLevels = [
    'Beggar',
    'Penniless',
    'Poor',
    'Respectable',
    'Rich',
    'Princely',
    'Fabulous',
  ];

  // Default land trade values per wealth level
  static const List<int> defaultLandTrade = [3, 3, 3, 4, 4, 3, 2];

  // Default sea trade values per wealth level
  static const List<int> defaultSeaTrade = [2, 2, 2, 4, 4, 5, 6];

  // Player colors and their associated names
  static const List<PlayerColorInfo> playerColors = [
    PlayerColorInfo('White', Colors.white, 'Ma\'aruf'),
    PlayerColorInfo('Black', Colors.black, 'Ali Baba'),
    PlayerColorInfo('Green', Colors.green, 'Scheherazade'),
    PlayerColorInfo('Yellow', Colors.amber, 'Zumurrud'),
    PlayerColorInfo('Red', Colors.red, 'Aladdin'),
    PlayerColorInfo('Blue', Colors.blue, 'Sinbad'),
  ];

  static const List<String> statusNames = [
    'Accursed',
    'Beast Form',
    'Beloved',
    'Blessed',
    'Crippled',
    'Determined',
    'Diseased',
    'Enslaved',
    'Ensorcelled',
    'Envious',
    'Fated',
    'Grief Stricken',
    'Imprisoned',
    'Insane',
    'Lost',
    'Love Struck',
    'Married',
    'On Pilgrimage',
    'Outlaw',
    'Pursued',
    'Respected',
    'Robe of Honor',
    'Scorned',
    'Sex-Changed',
    'Sultan',
    'Under Geas',
    'Vizier',
    'Wounded',
  ];

  static const List<String> statusDescriptions = [
    // Accursed
    'Whenever you roll the die for any reason, ask any player what number he wants you to use (that player may consult the Book of Tales before he gives you a number).\n\nTo get rid of Accursed: After the player has given you a number, roll the die to determine if you lose the status. If the number you roll is more than one point away from the number that was given, you are no longer Accursed. If you are Blessed you lose this status.',
    // Beast Form
    'You cannot choose Court on the Reaction Matrix; if you are ever forced to Court, you immediately get the Scorned status. You cannot gain or use the Seduction or Appearance skills while in Beast Form.\n\nTo get rid of Beast Form: If you give a Wealth level to a player in your space who has Magic, you lose this status.',
    // Beloved
    'Decide whether to accept or reject his/her love:\nIf you accept: You receive 2 Destiny points and become Married.\nIf you refuse: Roll one die and gain the following status:\n1-2 = Scorned, 3-4 = Pursued, 5-6 = Determined',
    // Blessed
    'Whenever you roll the die for any reason, you may choose what number to use (you may examine the Book of Tales before choosing a number). Does not affect Destiny Die.\n\nTo get rid of Blessed: After saying what number you will use, roll the die. If the number you roll is more than 1 point from the number you called, you lose this status. If you gain Accursed, you lose this status.',
    // Crippled
    'Your movement is reduced by 1. You cannot gain or use the Seduction or Appearance skills. In any encounter you double all Story Point awards.\n\nTo get rid of Crippled: If you gain Blessed or Respected, you lose this status.',
    // Determined
    'Once per encounter, you may decide to reject the Award Paragraph you receive. If you do this, you must go back to the Reaction Matrix and choose a different reaction.',
    // Diseased
    'Your movement is reduced by 1. If you pay 3 Destiny points while in the same space as another player, you may give him this status – but you keep it as well.\n\nTo get rid of Diseased: Give a Wealth level to a player in your space who has Scholarship.',
    // Enslaved
    'Each turn, you designate another player to be your "master." Any Destiny points or Treasures received during your turn go to him or her instead of you.\n\nTo get rid of Enslaved: You may "buy your freedom" if you gain a Wealth level while Enslaved. Simply expend the new Wealth level and lose this status.',
    // Ensorcelled
    'Each turn, another player of your choice decides where to move your piece.\n\nTo get rid of Ensorcelled: At the end of your turn, you and the player who moved your piece roll 1 die each. If you roll higher, you lose this status.',
    // Envious
    'You cannot win while Envious. In any encounter in which Rob is a possible reaction, you must choose it.\n\nTo get rid of Envious: You may pay 3 Destiny points to exchange this status for the On Pilgrimage status. If you receive 2 Wealth levels or a Treasure in any one encounter, you lose this status.',
    // Fated
    'Do not roll to determine who you will meet on an Encounter chart in the Book of Tales. Designate another player to decide. That player may consult the Book of Tales before choosing.\n\nTo get rid of Fated: If you gain a combined total of 4 or more Destiny and/or Story points, you lose this status.',
    // Grief Stricken
    'You may not use any Talent level skills during encounters; Master level skills may only be used at Talent level.\n\nTo lose Grief Stricken: When your Story points total reaches 8 or more, you lose this status.',
    // Imprisoned
    'You may not move. Lose loot if you have it, refer to the card for your encounter with the jailer.\n\nTo Lose Imprisoned: When your Story points reach 10 or more. If you give a Wealth level to a player in your space who has Beguiling or Stealth & Stealing, you lose this status.',
    // Insane
    'Each time you have an encounter, designate another player to choose your reaction on the Reaction Matrix.\n\nTo get rid of Insane: You lose this status if you gain a skill from an encounter.',
    // Lost
    'You may only move 1 space per turn.\n\nTo get rid of Lost: You may choose to not have a normal encounter on your turn, but rather a Badly Lost encounter on Matrix G.',
    // Love Struck
    'Your next turn your normal encounter is replaced by a special encounter, look at the card for details.\n\nTo lose Love Struck: Immediately after the encounter you lose this status. If you are married you cannot be Love Struck, instead you gain the Grief Stricken status.',
    // Married
    'You gain 1 Story point when you get this status. The next city you enter is where you make your home. After you have an encounter in another city, you must return to your home before you may end your turn in any other cities.',
    // On Pilgrimage
    'You cannot win the game while On Pilgrimage.\n\nTo get rid of On Pilgrimage: Place your Destination marker in any city not within 3 spaces of Mecca. You must enter and have at least 1 encounter in that city, then go to Mecca and have at least 1 encounter there.',
    // Outlaw
    'Mark the city nearest to your space with your Origins marker. If you have an encounter in that city, you automatically receive the Imprisoned status.\n\nTo get rid of Outlaw: If you become Imprisoned, you lose the Outlaw status.',
    // Pursued
    'On any subsequent turn, before you have an encounter, roll 1 die. On a roll of 1 or 2, instead of a regular encounter, you are found by your Pursuer. You encounter him/her on the Pursuing line of Matrix H.',
    // Respected
    'In any encounter in which a die roll is involved, you may roll a second time for an Award Paragraph after it is read to you if you don\'t like the first result. The 2nd roll stands.',
    // Robe of Honor
    'Gain 1 Destiny point immediately. You also become Respected and gain Wisdom.',
    // Scorned
    'All Destiny points awarded after receiving this status are changed to Story points awards. You may receive no new Wealth levels or skills.\n\nTo get rid of Scorned: You may trade this status for the On Pilgrimage status at the cost of 1 Destiny point.',
    // Sex-Changed
    'Turn your Player token to the other side to indicate your new sex. You cannot win while Sex-Changed.\n\nTo get rid of Sex-Changed: You must get the Sex-Changed status again to lose this status.',
    // Sultan
    'Your wealth automatically becomes Fabulous. You can count each city as 1 space when moving, ignoring terrain spaces in-between. Requires a combined total of 12 Destiny and Story points; otherwise you receive Vizier instead.',
    // Under Geas
    'You cannot win the game while Under Geas.\n\nTo lose Under Geas: Gain 3 destiny points to complete your Geas or break the Geas by paying 4 destiny points.',
    // Vizier
    'Immediately receive D1/S1/Courtly Graces/Wisdom. Place your Origins marker in the nearest city. You must return to your origin city after encounters in other cities.\n\nIf you have Piety and Scholarship at Master level and 12 Destiny and Story points, you may trade for Sultan status.',
    // Wounded
    'Lose the use of the following skills until you are no longer wounded: Stealth & Stealing, Magic, Weapon Use, Seduction, Appearance.\n\nTo get rid of Wounded: Skip your next turn and lose either 1 Destiny or 1 Story point, OR give a Wealth level to a player in your space who has Scholarship.',
  ];

  static const List<String> tokenNames = [
    'Appearance',
    'Beguiling',
    'Courtly Graces',
    'Enduring',
    'Luck',
    'Magic',
    'Piety',
    'Quick Thinking',
    'Scholarship',
    'Seafaring',
    'Seduction',
    'Stealth & Stealing',
    'Storytelling',
    'Survival',
    'Swagger',
    'Weapon Use',
    'Wilderness Lore',
    'Wisdom',
  ];

  // Encounter numbers that are excluded (no valid encounter)
  static const Set<int> excludedEncounters = {89, 96, 103, 104, 111, 112};
}

class PlayerColorInfo {
  final String colorName;
  final Color color;
  final String characterName;

  const PlayerColorInfo(this.colorName, this.color, this.characterName);
}
