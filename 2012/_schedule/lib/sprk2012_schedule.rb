require 'erb'
require 'yaml'
require 'forwardable'

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
      ERB.new(File.read(self.class.template_path)).result(binding)
    end

    def md(text)
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, :autolink => true)
      markdown.render(text.to_s)
    end
  end

  module Views
    # イベントテーブル
    class Grid
      include Renderable

      attr_reader :presentations

      def initialize(presentations)
        @presentations = presentations
      end

      def render_cell(presentation_id)
        presentation = presentations.detect {|presentation| presentation.id == presentation_id.to_s }
        cell = Cell.new(presentation)
        cell.render
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

    # ページのデータ
    class Metadata
      include Renderable

      partial!
    end
  end

  # 発表
  class Presentation
    include Localizable

    attr_localized :data, %w(title abstract references)

    def self.load_from_yaml(id, file_path)
      new(id, YAML.load_file(file_path))
    end

    def self.resource_path(root)
      @@resource_path = root
    end

    def self.all
      Dir[File.join(@@resource_path, '*.yml')].map do |path|
        id = File.basename(path, '.*')
        load_from_yaml(id, path)
      end
    end

    attr_reader :id, :data

    def initialize(id, data)
      @id = id
      @data = data
    end

    def presenters
      data['presenters'].map {|presenter_data| Presenter.new(presenter_data) }
    end

    def language
      data['language']
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

end
