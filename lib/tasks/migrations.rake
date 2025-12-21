namespace :migration do
  # Adds search_value to existing BoardgameName records
  # Execute after db/migrate/20251221224210_add_search_value_to_boardgame_names.rb
  task backfill_search_value_to_boardgamenames: :environment do
    Rails.logger.info("Backfilling BoardgameName#search_value")

    BATCH_SIZE = 1_000
    ENUMERATOR = BoardgameName.in_batches(of: BATCH_SIZE)
    N_BATCHES = ENUMERATOR.count

    ENUMERATOR.each_with_index do |batch, index|
      Rails.logger.info(format("Batch [%d/%d]", index + 1, N_BATCHES))

      batch.each do |bn|
        search_value = bn.send(:set_search_value)
        bn.update_columns(search_value:)
      end
    end
  end
end
