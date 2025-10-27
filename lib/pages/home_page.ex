defmodule HalostatueCa.HomePage do
  @moduledoc false

  use HalostatueCa.Component

  use Tableau.Page,
    layout: HalostatueCa.RootLayout,
    permalink: "/",
    title: "Welcome"

  def template(assigns) do
    recent_posts = get_posts(assigns.site, limit: 5)

    temple do
      section do
        h2 do
          "Welcome to halostatue.ca"
        end

        p do
          "This is Austin Ziegler's personal website and blog. I write about software development, "
          "open source projects, and various technical topics that interest me."
        end

        if Enum.empty?(recent_posts) do
          p class: "text-muted" do
            "No posts yet. Check back soon!"
          end
        else
          h3 do
            "Recent Posts"
          end

          post_list(recent_posts, show_tags: false)

          p do
            a href: "/posts" do
              "View all posts →"
            end
          end
        end
      end
    end
  end
end
