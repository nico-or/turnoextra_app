class UpdateDailyBoardgameDealsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    DailyDealsUpdateService.call
  end
end
