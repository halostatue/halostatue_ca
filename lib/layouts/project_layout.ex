defmodule HalostatueCa.ProjectLayout do
  @moduledoc false

  use Tableau.Layout, layout: HalostatueCa.RootLayout
  use HalostatueCa.Component

  def template(assigns) do
    related_tag = Map.get(assigns.page, :related_tag)
    related_posts = if related_tag, do: filter_posts_by_tag(assigns.posts, related_tag), else: []

    temple do
      article class: "page project-page", data_pagefind_body: true, data_pagefind_filter: "type:project" do
        if assigns.page[:title] do
          header class: "page-header" do
            h1 class: "page-title", data_pagefind_meta: "title" do
              assigns.page.title
            end

            if assigns.page[:description] do
              p class: "page-description text-muted" do
                assigns.page.description
              end
            end
          end
        end

        div class: "page-content" do
          render(assigns.inner_content)
        end

        if related_posts != [] do
          section id: "related-posts" do
            h2 do: "Related Posts"

            ul class: "post-list" do
              for post <- related_posts do
                post_list_item(post, show_excerpt: false)
              end
            end
          end
        end
      end
    end
  end

  defp filter_posts_by_tag(posts, tag) do
    posts
    |> Enum.filter(fn post ->
      tags = Map.get(post, :tags, [])
      tag in tags
    end)
    |> Enum.sort_by(& &1.date, {:desc, Date})
  end
end
