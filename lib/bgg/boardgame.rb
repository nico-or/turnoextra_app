module Bgg
  Boardgame = Data.define(
    :bgg_id,
    :thumbnail_url,
    :image_url,
    :title,
    :titles,
    :description,
    :year,
    :min_players,
    :max_players,
    :playingtime,
    :min_playtime,
    :max_playtime,
    :min_age,
    :links,
    :statistics,
  ) do
    [
      [ :categories, :boardgamecategory ],
      [ :mechanics, :boardgamemechanic ],
      [ :families, :boardgamefamily ],
      [ :integrations, :boardgameintegration ],
      [ :implementations, :boardgameimplementation ],
      [ :designers, :boardgamedesigner ],
      [ :artists, :boardgameartist ],
      [ :publishers, :boardgamepublisher ]
    ].each do |attribute, link_type|
      define_method attribute do
        links.filter_map { |link| link.value if link.type == link_type.to_s }
      end
    end

    def weight
      statistics&.averageweight
    end
  end
end
