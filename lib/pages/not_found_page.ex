defmodule HalostatueCa.NotFoundPage do
  @moduledoc """
  404 Not Found page.
  """
  use HalostatueCa.Component

  use Tableau.Page,
    layout: HalostatueCa.RootLayout,
    permalink: "/404",
    title: "Page Not Found"

  def template(assigns) do
    random_posts =
      assigns.site.pages
      |> Enum.filter(& &1[:__tableau_post_extension__])
      |> Enum.shuffle()
      |> Enum.take(20)
      |> Enum.map(fn post -> %{title: post.title, url: post.permalink} end)
      |> JSON.encode!()

    temple do
      section class: "not-found-page" do
        h1 do
          "404 - Page Not Found"
        end

        p do
          "The page you're looking for doesn't exist. You could read "

          span id: "random-post-link" do
            # JS will populate this
          end

          " or you could search:"
        end

        div id: "inline-search", class: "inline-search" do
          # Pagefind UI will be injected here
        end

        script type: "application/json", id: "random-posts-data" do
          random_posts
        end
      end
    end
  end
end
