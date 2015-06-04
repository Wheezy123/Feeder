class FeedEntry < ActiveRecord::Base
  attr_accessible :guid, :url, :title, :summary, :published_at

  def self.update_from_feed(feed_name)
    feed = Feed.find_by_name(feed_name)
    feed_data = Feedjira::Feed.fetch_and_parse(feed.feed_url)

    add_entries(feed_data.entries, feed)
  end








    private
      def self.add_entries(entries, feed)
        entries.each do |entry|
          break if exists? :entry_id => entry.id
          create!(
            entry_id: entry.id,
            url: entry.url,
            title: entry.title.sanitize,
            summary: entry.content.sanitize,
            published_at: entry.published
          )
        end
      end
    end

end
