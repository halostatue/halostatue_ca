defmodule HalostatueCa.RecipePostLayout do
  @moduledoc false

  use HalostatueCa.Component
  use Tableau.Layout, layout: HalostatueCa.RootLayout

  def template(assigns) do
    page = assigns.page

    temple do
      article class: "post h-recipe",
              data_pagefind_body: true,
              data_pagefind_filter: "type:post" do
        header class: "post-header" do
          h1 class: "post-title p-name" do
            page.title
          end

          post_header_meta(page)
        end

        div class: "post-content" do
          render(@inner_content)
        end
      end
    end
  end
end
