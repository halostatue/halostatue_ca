defmodule HalostatueCa.RootLayout do
  @moduledoc false

  use HalostatueCa.Component
  use Tableau.Layout

  def template(assigns) do
    # Clear any scripts from previous render
    clear_page_scripts()

    temple do
      "<!DOCTYPE html>"

      html lang: "en" do
        head do
          meta charset: "utf-8"
          meta http_equiv: "X-UA-Compatible", content: "IE=edge"
          meta name: "viewport", content: "width=device-width, initial-scale=1.0"

          # SEO and social meta tags
          meta name: "description",
               content: assigns.page[:description] || "Austin Ziegler's personal website and blog"

          meta name: "author", content: "Austin Ziegler"

          # AI training opt-out
          meta name: "robots", content: "noai, noimageai"

          # Open Graph
          meta property: "og:title", content: page_title(assigns)

          meta property: "og:description",
               content: assigns.page[:description] || "Austin Ziegler's personal website and blog"

          meta property: "og:type", content: og_type(assigns)
          meta property: "og:url", content: current_url(assigns)

          # Canonical URL
          link rel: "canonical", href: current_url(assigns)

          title do
            page_title(assigns)
          end

          link rel: "stylesheet", href: "/css/site.css"
          link rel: "alternate", type: "application/rss+xml", title: "RSS Feed", href: "/feed.xml"

          # Favicons
          link rel: "icon", href: "/favicon.ico", sizes: "32x32"
          link rel: "icon", href: "/favicon.svg", type: "image/svg+xml"
          link rel: "apple-touch-icon", href: "/apple-touch-icon.png"

          # Preload critical resources
          # link rel: "preload", href: "/css/site.css", as: "style"

          script src: "/js/site.js", defer: true

          # JSON-LD structured data
          script type: "application/ld+json" do
            json_ld(assigns)
          end
        end

        body do
          a href: "#main", class: "skip-to-content" do
            "Skip to content"
          end

          header class: "site-header", data_pagefind_ignore: true do
            div class: "site-header-top" do
              div class: "site-title" do
                a href: "/", style: "text-decoration: none; color: inherit;" do
                  "halostatue.ca"
                end
              end

              div class: "site-controls no-js" do
                button type: "button",
                       id: "search-trigger",
                       class: "search-trigger",
                       "data-label": "Search",
                       "aria-label": "Open search",
                       title: "Search (press /)" do
                  span class: "search-icon", "aria-hidden": "true" do
                    "🔍"
                  end

                  span class: "visually-hidden" do
                    "Search"
                  end
                end

                div class: "theme-switcher" do
                  button type: "button",
                         id: "theme-toggle",
                         class: "theme-toggle",
                         "data-label": "Theme: Auto",
                         "aria-label": "Change theme",
                         "aria-expanded": "false",
                         "aria-haspopup": "true" do
                    span id: "theme-icon", class: "theme-icon", "aria-hidden": "true" do
                      "🖥️"
                    end

                    span class: "visually-hidden" do
                      "Theme"
                    end
                  end

                  div id: "theme-menu",
                      class: "theme-menu",
                      role: "menu",
                      "aria-hidden": "true" do
                    button type: "button",
                           class: "theme-option",
                           "data-theme": "auto",
                           role: "menuitem" do
                      span class: "theme-icon", "aria-hidden": "true" do
                        "🖥️"
                      end

                      span do
                        "Auto"
                      end
                    end

                    button type: "button",
                           class: "theme-option",
                           "data-theme": "light",
                           role: "menuitem" do
                      span class: "theme-icon", "aria-hidden": "true" do
                        "☀️"
                      end

                      span do
                        "Light"
                      end
                    end

                    button type: "button",
                           class: "theme-option",
                           "data-theme": "dark",
                           role: "menuitem" do
                      span class: "theme-icon", "aria-hidden": "true" do
                        "🌙"
                      end

                      span do
                        "Dark"
                      end
                    end
                  end
                end
              end
            end

            nav class: "site-nav", role: "navigation", "aria-label": "Main navigation" do
              ul do
                li do
                  a href: "/" do
                    "Home"
                  end
                end

                li do
                  a href: "/posts" do
                    "Posts"
                  end
                end

                li do
                  a href: "/tags" do
                    "Tags"
                  end
                end

                li do
                  a href: "/about" do
                    "About"
                  end
                end
              end
            end
          end

          main id: "main", role: "main" do
            render(@inner_content)
          end

          # Modal search overlay
          div id: "search-modal", class: "search-modal", "aria-hidden": "true" do
            div class: "search-modal-backdrop", "data-search-close": "true" do
            end

            div class: "search-modal-content",
                role: "dialog",
                "aria-labelledby": "search-modal-title" do
              div class: "search-modal-header" do
                h2 id: "search-modal-title", class: "search-modal-title" do
                  "Search"
                end

                button type: "button",
                       class: "search-modal-close",
                       "data-search-close": "true",
                       "aria-label": "Close search" do
                  "×"
                end
              end

              div class: "search-modal-body" do
                div id: "modal-search" do
                  # Pagefind UI will be injected here
                end
              end
            end
          end

          footer class: "site-footer" do
            p do
              "© #{Date.utc_today().year} Austin Ziegler. Built with "

              a href: "https://hexdocs.pm/tableau" do
                "Tableau"
              end

              " and "

              a href: "https://hexdocs.pm/temple" do
                "Temple"
              end

              "."
            end
          end

          # Inject collected scripts from excerpts
          scripts = get_page_scripts()

          if scripts != "" do
            scripts
          end

          c &live_reload/1
        end
      end
    end
  end

  if Mix.env() == :dev do
    defdelegate live_reload(x), to: Tableau
  else
    def live_reload(_), do: ""
  end

  defp page_title(assigns) do
    case [assigns.page[:title], "halostatue.ca"] do
      [nil, site] -> site
      [title, site] -> "#{title} | #{site}"
    end
  end

  defp current_url(assigns) do
    "#{base_url()}#{assigns.page[:permalink] || "/"}"
  end

  defp base_url do
    Application.get_env(:tableau, :config)[:url] || "https://halostatue.ca"
  end

  defp og_type(assigns) do
    if assigns.page[:__tableau_post_extension__], do: "article", else: "website"
  end

  defp json_ld(assigns) do
    base = %{
      "@context" => "https://schema.org",
      "@type" => "WebSite",
      "name" => "halostatue.ca",
      "url" => base_url(),
      "author" => %{
        "@type" => "Person",
        "name" => "Austin Ziegler",
        "url" => "#{base_url()}/about"
      }
    }

    schema =
      if assigns.page[:__tableau_post_extension__] do
        %{
          "@context" => "https://schema.org",
          "@type" => "BlogPosting",
          "headline" => assigns.page[:title],
          "url" => current_url(assigns),
          "datePublished" => Date.to_iso8601(assigns.page[:date]),
          "author" => %{
            "@type" => "Person",
            "name" => "Austin Ziegler",
            "url" => "#{base_url()}/about"
          },
          "publisher" => %{
            "@type" => "Person",
            "name" => "Austin Ziegler"
          },
          "description" => assigns.page[:description] || "Austin Ziegler's personal website and blog"
        }
      else
        base
      end

    JSON.encode!(schema)
  end
end
