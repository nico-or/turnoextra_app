module Bgg
  Boardgame = Data.define(
    :bgg_id,
    :year,
    :title,
    :titles,
    :description,
    :thumbnail_url,
    :image_url,
    :min_players,
    :max_players,
    :min_playtime,
    :max_playtime,
    :playingtime,
    :statistics,
    :links
  ) do
    [
      [ :categories, :boardgamecategory ],
      [ :mechanics, :boardgamemechanic ],
      [ :designers, :boardgamedesigner ],
      [ :artists, :boardgameartist ]
    ].each do |attribute, link_type|
      define_method attribute do
        links.filter_map { |link| link.value if link.type == link_type.to_s }
      end
    end
  end
end
