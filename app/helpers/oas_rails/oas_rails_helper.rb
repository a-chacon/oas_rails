module OasRails
  module OasRailsHelper # rubocop:disable Metrics/ModuleLength
    def rapidoc_configuration_defaults
      {
        "spec-url" => "#{OasRails::Engine.routes.find_script_name({})}.json",
        "show-header" => "false",
        "font-size" => "largest",
        "show-method-in-nav-bar" => "as-colored-text",
        "nav-item-spacing" => "relaxed",
        "allow-spec-file-download" => "true",
        "schema-style" => "table",
        "sort-tags" => "true",
        "persist-auth" => "true"
      }
    end

    def rapidoc_configuration_attributes
      rapidoc_configuration_defaults.merge(
        rapidoc_theme(OasRails.config.rapidoc_theme),
        OasRails.config.rapidoc_configuration
      ).map { |k, v| %(#{k}=#{ERB::Util.html_escape(v)}) }.join(' ')
    end

    def rapidoc_logo_url
      OasRails.config.rapidoc_logo_url
    end

    THEMES = {
      'dark' => {
        'theme' => 'dark',
        'bg-color' => '#333',
        'text-color' => '#BBB'
      },
      'light' => {
        'theme' => 'light',
        'bg-color' => '#FFF',
        'text-color' => '#444'
      },
      'night' => {
        'theme' => 'dark',
        'bg-color' => '#14191f',
        'text-color' => '#aec2e0'
      },
      'mud' => {
        'theme' => 'dark',
        'bg-color' => '#403635',
        'text-color' => '#c3b8b7'
      },
      'cofee' => {
        'theme' => 'dark',
        'bg-color' => '#36312C',
        'text-color' => '#ceb8a0'
      },
      'forest' => {
        'theme' => 'dark',
        'bg-color' => '#384244',
        'text-color' => '#BDD6DB'
      },
      'olive' => {
        'theme' => 'dark',
        'bg-color' => '#2a2f31',
        'text-color' => '#acc7c8'
      },
      'outerspace' => {
        'theme' => 'dark',
        'bg-color' => '#2D3133',
        'text-color' => '#CAD9E3'
      },
      'ebony' => {
        'theme' => 'dark',
        'bg-color' => '#2B303B',
        'text-color' => '#dee3ec'
      },
      'snow' => {
        'theme' => 'light',
        'bg-color' => '#FAFAFA',
        'text-color' => '#555'
      },
      'green' => {
        'theme' => 'light',
        'bg-color' => '#f9fdf7',
        'text-color' => '#375F1B'
      },
      'blue' => {
        'theme' => 'light',
        'bg-color' => '#ecf1f7',
        'text-color' => '#133863'
      },
      'beige' => {
        'show-header' => 'true',
        'theme' => 'light',
        'bg-color' => '#fdf8ed',
        'text-color' => '#342809'
      },
      'graynav' => {
        'show-header' => 'false',
        'theme' => 'light',
        'nav-bg-color' => '#3e4b54',
        'nav-accent-color' => '#fd6964',
        'primary-color' => '#ea526f'
      },
      'purplenav' => {
        'show-header' => 'false',
        'theme' => 'light',
        'nav-accent-color' => '#ffd8e7',
        'nav-bg-color' => '#666699',
        'primary-color' => '#ea526f',
        'bg-color' => '#fff9fb'
      },
      'lightgraynav' => {
        'show-header' => 'false',
        'theme' => 'light',
        'nav-bg-color' => '#fafafa',
        'nav-hover-text-color' => '#9b0700',
        'nav-hover-bg-color' => '#ffebea',
        'primary-color' => '#F63C41',
        'bg-color' => '#ffffff'
      },
      'darkbluenav' => {
        'show-header' => 'false',
        'theme' => 'light',
        'bg-color' => '#f9f9fa',
        'nav-bg-color' => '#3f4d67',
        'nav-text-color' => '#a9b7d0',
        'nav-hover-bg-color' => '#333f54',
        'nav-hover-text-color' => '#fff',
        'nav-accent-color' => '#f87070',
        'primary-color' => '#5c7096'
      },
      'rails' => {
        'theme' => 'light',
        'bg-color' => '#FFFFFF',
        'nav-bg-color' => '#101828',
        'nav-text-color' => '#fff',
        'nav-hover-bg-color' => '#261B23',
        'nav-hover-text-color' => '#fff',
        'nav-accent-color' => '#D30001',
        'primary-color' => '#D30001'
      }
    }.freeze

    def rapidoc_theme(theme_name)
      THEMES[theme_name] || {}
    end
  end
end
