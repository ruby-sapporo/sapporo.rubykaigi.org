#!/usr/bin/env ruby
# coding: utf-8

require 'yaml'
require 'erb'
require 'pathname'

def i18n(value, lang='en')
  value[lang] || value['en']
end

def render_web(locale)
  @locale = locale
  @title = {'ja' => '実行委員会', 'en' => 'Organizing Team'}

  script_path = Pathname.new(__FILE__)
  basedir = script_path.dirname
  yaml_path = basedir + 'team.yml'
  template_path = basedir + './templates/team.html.erb'
  dest_path = basedir + ('../../_includes/2012/%s/team.html' % locale)

  @team = YAML.load_file(yaml_path)

  @path_to_script = script_path.expand_path.relative_path_from(
    dest_path.expand_path.dirname
  ).to_path
  @path_to_yaml = yaml_path.expand_path.relative_path_from(
    dest_path.expand_path.dirname
  ).to_path

  erb_template = File.read(template_path)
  rendered_html = ERB.new(erb_template, nil, '-').result(binding)

  File.write(dest_path, rendered_html)
end

render_web('ja')
render_web('en')
