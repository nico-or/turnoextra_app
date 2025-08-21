# Create a Boardgame record and its associations from a Bgg::Boardgame object.
# If a Boardgame record with the same bgg_id exists in the database, it is updated.
class ThingCreator
  def initialize(boardgame)
    @boardgame = boardgame
  end

  def create!
    boardgame = find_or_create_boardgame!
    create_names!(boardgame, @boardgame.titles)
    boardgame
  end

  private

  def find_or_create_boardgame!
    boardgame = ::Boardgame.find_or_initialize_by(bgg_id: @boardgame.bgg_id)
    boardgame.assign_attributes(
      title: @boardgame.title,
      year: @boardgame.year,
      image_url: @boardgame.image_url,
      thumbnail_url: @boardgame.thumbnail_url,
      min_players: @boardgame.min_players,
      max_players: @boardgame.max_players,
      min_playtime: @boardgame.min_playtime,
      max_playtime: @boardgame.max_playtime,
      weight: @boardgame.weight
      )
    boardgame.save!
    boardgame
  end

  def create_names!(boardgame, names)
    names.each do |name|
      boardgame.boardgame_names.create(value: name, preferred: false)
    end
  end
end
