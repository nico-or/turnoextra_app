module Bgg::Versions::XmlV2
  module ThingType
    BOARDGAME = "boardgame"
    BOARDGAME_EXPANSION = "boardgameexpansion"
    BOARDGAME_ACCESSORY = "boardgameaccessory"
    VIDEOGAME = "videogame"
    RPG_ITEM = "rpgitem"
    RPG_ISSUE = "rpgissue"

    ALL = [
      BOARDGAME,
      BOARDGAME_EXPANSION,
      BOARDGAME_ACCESSORY,
      VIDEOGAME,
      RPG_ITEM,
      RPG_ISSUE
    ].freeze
  end
end
