require "test_helper"
require "ostruct"

class SearchResultsRankerServiceTest < ActiveSupport::TestCase
  def setup
    @max_rank = 30_000 # real value: 28_413 as of (2025-05-13)
  end

  test "amazonas" do
    skip
    # FIXME: difficult test case.
    # The general heuristic is to prioritize rank, then name, then year
    # This test case is a low-rank but new boardgame. It ends up shadowed by an older,
    # better ranked game with the same name...
    #
    ranks =  {
      342_550 => OpenStruct.new(bgg_id: 342_550, rank: 13_312),
      125_446 => OpenStruct.new(bgg_id: 125_446, rank: 0),
      15_157 => OpenStruct.new(bgg_id: 15_157, rank: 4_994),
      10_848 => OpenStruct.new(bgg_id: 10_848, rank: 0)
    }

    results =  load_results("bgg/api/v2/search_amazonas.xml")
    service = SearchResultsRankerService.new("amazonas", results, ranks:, max_rank: @max_rank)
    ranked_results = service.call
    result = ranked_results.first

    assert_equal 342_550, result.bgg_id
  end

  test "metro" do
    ranks =  {
      559 => OpenStruct.new(bgg_id: 559, rank: 2_443),
      261_456 => OpenStruct.new(bgg_id: 261_456, rank: 0),
      273_714 => OpenStruct.new(bgg_id: 273_714, rank: 0)
    }

    results =  load_results("bgg/api/v2/search_metro.xml")
    service = SearchResultsRankerService.new("metro", results, ranks:, max_rank: @max_rank)
    ranked_results = service.call
    result = ranked_results.first

    assert_equal 559, result.bgg_id
  end

  test "campeones" do
    ranks = {
      159_869 => OpenStruct.new(bgg_id: 159_869, rank: 0),
      391_565 => OpenStruct.new(bgg_id: 391_565, rank: 11_528)
    }

    results =  load_results("bgg/api/v2/search_campeones.xml")
    service = SearchResultsRankerService.new("campeones", results, ranks:, max_rank: @max_rank)
    ranked_results = service.call
    result = ranked_results.first

    assert_equal 391_565, result.bgg_id
  end

  test "dorfromantik" do
    skip
    ranks = {
      424_774 => OpenStruct.new(bgg_id: 424_774, rank: 2_594),
      370_591 => OpenStruct.new(bgg_id: 370_591, rank: 348),
      395_364 => OpenStruct.new(bgg_id: 395_364, rank: 5_075)
    }

    results =  load_results("bgg/api/v2/search_dorfromantik.xml")
    service = SearchResultsRankerService.new("dorfromantik", results, threshold: 0.6, ranks:, max_rank: @max_rank)
    ranked_results = service.call
    result = ranked_results.first

    # FIXME: find a way to score "Dorfromantik: The Board Game" over "Dorfromantik: Sakura"
    assert_equal 370_591, result.bgg_id
  end

  private

  def load_results(filepath)
    xml = file_fixture(filepath).read
    parsed = Nokogiri::XML(xml)
    Bgg::Versions::XmlV2::SearchResponseParser.parse!(parsed)
  end
end
