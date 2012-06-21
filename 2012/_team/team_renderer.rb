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

  template_path = File.join(
    File.dirname(__FILE__),
    './templates/team.html.erb'
  )
  erb_template = File.read(template_path)
  rendered_html = ERB.new(erb_template, nil, '-').result(binding)

  dest_path = File.join(
    File.dirname(__FILE__),
    '../../_includes/2012/%s/team.html' % locale
  )
  File.write(dest_path, rendered_html)
end

render_web('ja')
render_web('en')
