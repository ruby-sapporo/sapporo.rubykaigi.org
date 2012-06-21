#!/usr/bin/env ruby
# coding: utf-8

require 'yaml'
require 'erb'

def i18n(value, lang='en')
  value[lang] || value['en']
end

def render_web(locale)
  @locale = locale
  @title = {'ja' => '実行委員会', 'en' => 'Organizing Team'}
  @team = YAML.load_file(File.join(File.dirname(__FILE__), 'team.yml'))
  open(File.join(File.dirname(__FILE__), '../../_includes/2012/%s/team.html' % locale), 'w') do |f|
    f << ERB.new(File.read('./templates/team.html.erb')).result(binding)
  end
end

render_web('ja')
render_web('en')
