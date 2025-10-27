defmodule HalostatueCa.TagsPage do
  @moduledoc """
  Page that lists all tags with post counts.
  """
  use HalostatueCa.Component

  use Tableau.Page,
    layout: HalostatueCa.RootLayout,
    permalink: "/tags",
    title: "Tags"

  def template(assigns) do
    sorted_tags = Enum.sort_by(assigns.tags, fn {_, posts} -> length(posts) end, :desc)

    temple do
      section do
        h2 do
          "Tags"
        end

        if Enum.empty?(sorted_tags) do
          p class: "text-muted" do
            "No tags found."
          end
        else
          p class: "text-muted" do
            "#{length(sorted_tags)} tag#{if length(sorted_tags) != 1, do: "s"}"
          end

          ul class: "tag-list" do
            for {tag, posts} <- sorted_tags do
              li class: "tag-list-item" do
                a href: tag.permalink, class: "tag-link" do
                  tag.tag
                end

                span class: "tag-count" do
                  " (#{length(posts)})"
                end
              end
            end
          end
        end

        p do
          a href: "/posts" do
            "← Back to all posts"
          end
        end
      end
    end
  end
end
