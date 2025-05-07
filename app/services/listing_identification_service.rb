class ListingIdentificationService < ApplicationService
  attr_reader :listing

  def initialize(listing)
    @listing = listing
  end

  def call
    return if skip_if(listing.failed_identification?, "previous failed identification") ||
              skip_if(listing.boardgame.present?, "already identified")

    listing_siblings = listings_with_same_title(listing.title)

    best_search_result = find_best_search_result
    unless best_search_result
      count = fail_identification(listing_siblings)
      log_fail(count, "no match")
      return
    end

    boardgame = find_boardgame(best_search_result)
    unless boardgame
      count = fail_identification(listing_siblings)
      log_fail(count, "no boardgame")
      return
    end

    boardgame_siblings = listings_with_same_title(boardgame.title)
    records_to_update = listing_siblings.or(boardgame_siblings)
    count = records_to_update.update_all(boardgame_id: boardgame.id, failed_identification: false)

    Rails.logger.info { "[Identification] Success #{count}x[#{listing.title}] records as [#{boardgame.title}]." }
  end

  private

  def skip_if(condition, reason)
    return unless condition

    log_skip(reason)
    true
  end

  def log_skip(reason)
    Rails.logger.info { "[Identification] Skipped [#{listing.title}]. (#{reason})" }
  end

  def log_fail(count, reason)
    Rails.logger.info { "[Identification] Failed #{count}x[#{listing.title}] records. (#{reason})" }
  end

  def listings_with_same_title(string)
    Listing.where("LOWER(title) = LOWER(?)", string)
  end

  def find_best_search_result
    RankedSearchService.call(listing.title, Bgg::Client).first
  end

  def find_boardgame(search_result)
    Boardgame.find_by(bgg_id: search_result.id)
  end

  def fail_identification(collection)
    collection.update_all({ failed_identification: true })
  end
end
