defmodule HalostatueCa.PostsPage do
  @moduledoc false

  use HalostatueCa.Component

  def template(assigns) do
    posts = assigns.page.posts
    page_number = assigns.page.page_number
    total_pages = assigns.page.total_pages
    prev_page = assigns.page[:prev_page]
    next_page = assigns.page[:next_page]

    temple do
      section do
        h2 do
          "All Posts"
        end

        post_list(posts)

        if total_pages && total_pages > 1 do
          nav class: "pagination" do
            if page_number > 1 do
              a href: "/posts", class: "pagination-first" do
                "‹‹ First"
              end
            end

            if prev_page do
              a href: if(prev_page == 1, do: "/posts", else: "/posts/#{prev_page}"), class: "pagination-prev" do
                "‹ Previous"
              end
            end

            span class: "pagination-info" do
              "Page #{page_number} of #{total_pages}"
            end

            if next_page do
              a href: "/posts/#{next_page}", class: "pagination-next" do
                "Next ›"
              end
            end

            if page_number < total_pages do
              a href: "/posts/#{total_pages}", class: "pagination-last" do
                "Last ››"
              end
            end
          end
        end
      end
    end
  end
end
