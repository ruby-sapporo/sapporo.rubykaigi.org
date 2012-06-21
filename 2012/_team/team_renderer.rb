#!/usr/bin/env ruby
# coding: utf-8

require 'yaml'

def i18n(value, lang='en')
  value[lang] || value['en']
end

def gravatar_tag(id, size=32)
  '<img alt="avatar" height="32" src="http://www.gravatar.com/avatar/%s?s=%d" width="%d">' % [id, size, size]
end

def render_web(lang)
  open('team/%s.md' % lang, 'w') do |f|
    title = {'ja' => '実行委員会', 'en' => 'Team'}
    f.puts "# " + i18n(title, lang)
    items = YAML.load_file('team.yml')
    items.each do |item|
      section = item['section']
      f.puts "## " + i18n(section['name'], lang)
      people = section['people']
      people.each do |person|
        f.puts "### " + i18n(person['name'], lang)
        if person['gravatar']
          f.puts gravatar_tag(person['gravatar'])
          f.puts
        end
        f.puts i18n(person['affiliation'], lang)
      end
      f.puts
    end
  end
end

def render_qwik(lang)
  open('team/%s.qwik' % lang, 'w') do |f|
    f.puts "{{schedule"
    f.puts "|名前|"
    items = YAML.load_file('team.yaml')
    items.each do |item|
      section = item['section']
      people = section['people']
      people.each do |person|
        f.puts "|%s|" % i18n(person['name'], lang)
      end
    end
    f.puts "}}"
  end
end

render_web('ja')
render_web('en')
render_qwik('ja')
