#!/usr/bin/env ruby
# coding: utf-8

require 'yaml'
require 'erb'

def i18n(value, lang='en')
  value[lang] || value['en']
end

def gravatar_tag(id, size=32)
  if id
    '<img alt="avatar" height="32" src="http://www.gravatar.com/avatar/%s?s=%d" width="%d">' % [id, size, size]
  else
    '<img alt="avatar" height="32" src="/2012/images/avatar.png">'
  end
end

def render_web(locale)
  open('team/%s.md' % locale, 'w') do |f|
    @locale = locale
    @title = {'ja' => '実行委員会', 'en' => 'Team'}
    @team = YAML.load_file('team.yml')
    f << ERB.new(File.read('./templates/team.html.erb')).result(binding)
  end
end

render_web('ja')
render_web('en')
