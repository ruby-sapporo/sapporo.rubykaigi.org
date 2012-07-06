#!/usr/bin/env ruby

require 'open-uri'
require 'rss'
require 'pathname'
require 'cgi'

def remove_tailing_hashtag(title)
  title.sub(/\s*#sprk2012\z/, '')
end

def rubykaigi_nikki_entries(rdf_url='http://rubykaigi.tdiary.net/index.rdf')
  rdf_body = URI(rdf_url).read
  rss = RSS::Parser.parse(rdf_body)

  rss.items.map do |item|
    tags = item.dc_subjects.map(&:content)
    {
      title: remove_tailing_hashtag(item.title),
      time: item.date,
      content: item.content_encoded,
      tags: tags,
      language: tags.include?('english') ? 'en' : 'ja',
      link: item.link
    }
  end
end

def render_entries(entries)
  rendered = ""
  entries.each do |entry|
    date = entry[:time].strftime('%Y-%m-%d')
    rendered << <<-EOS
<li>#{date} <a href="#{entry[:link]}">#{CGI.escapeHTML(entry[:title])}</a></li>
    EOS
  end
  rendered
end

KAIGI_TAG = 'sappororubykaigi2012'

kaigi_entries = rubykaigi_nikki_entries.select {|entry|
  entry[:tags].include?(KAIGI_TAG)
}

%w(ja en).each do |language|
  entries = kaigi_entries.select {|entry|
    entry[:language] == language
  }
  dest_path = Pathname.new(__FILE__) + "../../../_includes/2012/#{language}/headline.html"
  puts "Writing %s (%d entries)" % [dest_path, entries.size]

  rendered = render_entries(entries)
  File.write(dest_path, rendered)
end
