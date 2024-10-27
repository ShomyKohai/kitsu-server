class UpdateUnitStatusForTitledStuff < ActiveRecord::Migration[6.1]
  using UpdateInBatches

  def change
    Episode.where("titles->canonical_title !~ '^Episode \d+$'")
      .update_in_batches(status: :validated)
    Chapter.where("titles->canonical_title !~ '^Chapter \d+$'")
      .update_in_batches(status: :validated)
    Episode.joins("LEFT JOIN anime ON anime.id = episodes.media_id AND episodes.media_type = 'Anime'")
      .where("anime.episode_count IS NOT NULL AND anime.episode_count >= episodes.number")
      .update_in_batches(status: :validated)
    Chapter.joins(:manga)
      .where("manga.chapter_count IS NOT NULL AND manga.chapter_count >= chapters.number")
      .update_in_batches(status: :validated)
  end
end
