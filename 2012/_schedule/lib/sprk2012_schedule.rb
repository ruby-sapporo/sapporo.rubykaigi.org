require 'erb'
require 'yaml'
require 'forwardable'
require 'cgi'

require 'i18n'
require 'redcarpet'

module SPRK2012

  # 多言語化機能
  module Localizable
    SUPPORTED_LOCALES = %w(en ja)
    PRIMARY_LOCALE = SUPPORTED_LOCALES.first

    # setup i18n
    ::I18n.available_locales = SUPPORTED_LOCALES

    def self.add_locale(paths)
      ::I18n.load_path.concat(paths)
    end

    def self.included(base)
      base.instance_eval do
        def attr_localized(source, attr_names)
          attr_names.each do |attr|
            define_method attr do
              localize(__send__(source)[attr])
            end
          end
        end
      end
    end

    def localize(translations)
      translations[I18n.locale.to_s] || translations[PRIMARY_LOCALE]
    end
  end

  # レンダー機能
  module Renderable
    include Localizable
    extend Forwardable
    def_delegator :I18n, :translate, :t

    def self.included(base)
      base.instance_eval do
        def self.template_path
          basename = name.split('::').last.downcase
          filename = '%s.erb' % [basename]
          filename = '_' + filename if @partial
          File.join(@@root, filename)
        end

        def self.partial!
          @partial = true
        end
      end
    end

    def self.template_root(root)
      @@root = root
    end

    def render
      ERB.new(File.read(self.class.template_path), nil, '-').result(binding)
    end

    def md(text)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true)
      markdown.render(text.to_s)
    end

    def escape_html(str)
      CGI.escape_html(str.to_s)
    end
  end

  # yaml からのロード機能
  module YamlLoader
    def load_from_yaml(id, file_path)
      new(id, YAML.load_file(file_path))
    end

    def resource_path(root)
      @resource_path = root
    end

    def all
      Dir[File.join(@resource_path, '*.yml')].map do |path|
        id = File.basename(path, '.*')
        load_from_yaml(id, path)
      end
    end
  end

  module Views
    # イベントテーブル
    class Grid
      include Renderable

      attr_reader :presentations, :sub_events

      def initialize(presentations, sub_events)
        @presentations = presentations
        @sub_events = sub_events
      end

      def render_cell(presentation_id)
        presentation = presentations.detect {|presentation| presentation.id == presentation_id.to_s }
        cell = Cell.new(presentation)
        cell.render
      end

      def sub_event(sub_event_id)
        sub_events.detect {|sub_event| sub_event.id == sub_event_id.to_s }
      end

      def link_to_sub_event(sub_event_id)
        sub_event = sub_event(sub_event_id)
        return nil if sub_event.title.nil?

        '<a href="#%s">%s</a>' % [sub_event_html_id(sub_event_id), sub_event.title]
      end

      def sub_event_html_id(sub_event_id)
        'subEvent%s' % sub_event_id
      end
    end

    # イベント詳細
    class Detail
      include Renderable

      attr_reader :presentation

      def initialize(presentation)
        @presentation = presentation
      end
    end

    # イベント詳細枠
    class Cell < Detail
      partial!
    end

    # LTページ
    class LT
      include Renderable

      attr_reader :presentations

      def initialize(presentations)
        @presentations = presentations
      end

      def render_line(presentation_id)
        presentation = presentations.detect {|presentation| presentation.id == presentation_id.to_s }
        throw 'ID=%s is not found.' % presentation_id unless presentation
        line = Line.new(presentation)
        line.render
      end
    end

    # イベント詳細行
    class Line < Detail
      partial!
    end

    # ページのデータ
    class Metadata
      include Renderable

      partial!
    end
  end

  # 発表
  class Presentation
    extend YamlLoader
    include Localizable

    attr_localized :data, %w(title abstract references)

    attr_reader :id, :data

    %w(language vimeo_id speakerdeck_id slideshare_id).each do |attr_name|
      define_method attr_name do
        data[attr_name]
      end
    end

    def initialize(id, data)
      @id = id
      @data = data
    end

    def presenters
      data['presenters'].map {|presenter_data| Presenter.new(presenter_data) }
    end

    def vimeo_tag
      %{<iframe src="http://player.vimeo.com/video/#{vimeo_id}" width="500" height="281" frameborder="0" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>}
    end

    def vimeo_exist?
      !!vimeo_id
    end

    def canceled?
      data['canceled']
    end

    def slide_exist?
      !!slide_tag
    end

    def slide_tag(width=nil, height=nil)
      speakerdeck_tag || slideshare_tag(width, height)
    end

    def speakerdeck_tag
      return nil unless speakerdeck_id
      %{<script async class="speakerdeck-embed" data-id="#{speakerdeck_id}" data-ratio="1.3333333333333333" src="//speakerdeck.com/assets/embed.js"></script>}
    end

    def slideshare_tag(width, height)
      width ||= 427
      height ||= 356
      return nil unless slideshare_id
      %{<iframe src="http://www.slideshare.net/slideshow/embed_code/#{slideshare_id}" width="#{width}" height="#{height}" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC;border-width:1px 1px 0;margin-bottom:5px" allowfullscreen> </iframe>}
    end
  end

  # 発表者
  class Presenter
    include Localizable

    attr_localized :data, %w(name affiliation bio)

    attr_reader :data

    def initialize(data)
      @data = data
    end

    def github
      data['github']
    end
  end

  # サブイベント
  class SubEvent
    extend YamlLoader
    include Localizable

    attr_localized :data, %w(title abstract others)

    attr_reader :id, :data

    def initialize(id, data)
      @id = id
      @data = data
    end
  end

end
