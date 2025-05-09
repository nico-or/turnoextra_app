class ListingIdentificationService < ApplicationService
  attr_reader :listing

  def initialize(listing)
    @listing = listing
  end

  def call
    return if skip_identification?

    if (boardgame = identify_boardgame)
      update_matching_records(boardgame)
    end
  end

  private

  def skip_identification?
    return true if skip_if(listing.failed_identification?, "previous failed identification")
    return true if skip_if(listing.boardgame.present?, "already identified")

    false
  end

  def identify_boardgame
    best_result = find_best_search_result
    unless best_result
      fail_all_siblings("no match")
      return nil
    end

    boardgame = find_boardgame(best_result)
    unless boardgame
      fail_all_siblings("no boardgame")
      return nil
    end

    boardgame
  end

  def update_matching_records(boardgame)
    listing_siblings = listings_with_same_title(listing.title)
    boardgame_siblings = listings_with_same_title(boardgame.title)

    records_to_update = listing_siblings.or(boardgame_siblings)
    count = records_to_update.update_all(boardgame_id: boardgame.id, failed_identification: false)

    log_success(count, boardgame.title)
  end

  def skip_if(condition, reason)
    return unless condition

    log_skip(reason)
    true
  end

  def fail_all_siblings(reason)
    siblings = listings_with_same_title(listing.title)
    count = siblings.update_all(failed_identification: true)
    log_fail(count, reason)
  end

  def find_best_search_result
    RankedSearchService.call(listing.title).first
  end

  def find_boardgame(search_result)
    Boardgame.find_by(bgg_id: search_result.id)
  end

  def listings_with_same_title(string)
    Listing.where("LOWER(title) = LOWER(?)", string)
  end

  def log_skip(reason)
    Rails.logger.info { "[Identification] Skipped [#{listing.title}]. (#{reason})" }
  end

  def log_fail(count, reason)
    Rails.logger.info { "[Identification] Failed #{count}x[#{listing.title}] records. (#{reason})" }
  end

  def log_success(count, boardgame_title)
    Rails.logger.info { "[Identification] Success #{count}x[#{listing.title}] records as [#{boardgame_title}]." }
  end
end
