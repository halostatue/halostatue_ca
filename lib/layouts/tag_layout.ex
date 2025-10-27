defmodule HalostatueCa.TagLayout do
  @moduledoc """
  Layout for dynamic tag pages that show all posts with a specific tag.
  """
  use HalostatueCa.Component
  use Tableau.Layout, layout: HalostatueCa.RootLayout

  def template(assigns) do
    tag = assigns.page.tag
    posts = assigns.page.posts

    temple do
      section do
        h2 do
          "Posts tagged \"#{tag}\""
        end

        p class: "text-muted" do
          "#{length(posts)} post#{if length(posts) != 1, do: "s"}"
        end

        post_list(posts, empty_message: "No posts found with this tag.")

        p do
          a href: "/posts" do
            "← Back to all posts"
          end
        end
      end
    end
  end
end
