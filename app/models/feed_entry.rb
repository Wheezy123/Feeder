class FeedEntry < ActiveRecord::Base
  #attr_accessor :guid, :url, :title, :summary, :published_at

  def self.update_from_feed(feed_name)
    feed = Feed.find_by_name(feed_name)
    feed_data = Feedjira::Feed.fetch_and_parse(feed.feed_url)

    add_entries(feed_data.entries, feed)
  end

  def self.get_from_feed(url)
    data = Feedjira::Feed.fetch_and_parse(url)
    data.entries.each do |entry|
      FeedEntry.create(
        name: entry.title,
        url: entry.url,
        summary: entry.summary
      )
    end
  end


  def self.get_cnn_stories
    url = 'http://rss.cnn.com/rss/cnn_topstories.rss'
    obj = Feedjira::Feed.fetch_and_parse(url)
    obj.entries.each do |entry|
      FeedEntry.create(
        name: entry.title,
        url: entry.url,
        summary: entry.summary
      )
    end
  end

  def self.get_tribune_stories
    url = 'http://www.chicagotribune.com/news/local/breaking/rss2.0.xml'
    obj = Feedjira::Feed.fetch_and_parse(url)
    obj.entries.each do |entry|
      FeedEntry.create(
        name: entry.title,
        url: entry.url,
        summary: entry.summary
      )
    end
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
