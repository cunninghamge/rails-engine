class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.select_records(per_page, page)
    results = (per_page || 20).to_i
    skipped_pages = [page.to_i, 1].max - 1
    limit(results).offset(results * skipped_pages)
  end
end
