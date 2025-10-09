module ApplicationHelper
  module ApplicationHelper
    # Turbo無効リンク
    def link_to_no_turbo(name = nil, options = nil, html_options = nil, &block)
      html_options ||= {}
      html_options[:data] ||= {}
      html_options[:data][:turbo] = "false"
      link_to(name, options, html_options, &block)
    end

    # Turbo無効フォーム
    def form_with_no_turbo(model: nil, scope: nil, url: nil, format: nil, **options, &block)
      options[:data] ||= {}
      options[:data][:turbo] = "false"
      form_with(model: model, scope: scope, url: url, format: format, **options, &block)
    end
  end

end
