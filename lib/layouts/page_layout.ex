defmodule HalostatueCa.PageLayout do
  @moduledoc false

  use HalostatueCa.Component
  use Tableau.Layout, layout: HalostatueCa.RootLayout

  def template(assigns) do
    temple do
      article class: "page", data_pagefind_body: true, data_pagefind_filter: "type:page" do
        if @page[:title] do
          header class: "page-header" do
            h1 class: "page-title", data_pagefind_meta: "title" do
              @page.title
            end

            if @page[:description] do
              p class: "page-description text-muted" do
                @page.description
              end
            end
          end
        end

        div class: "page-content" do
          render(@inner_content)
        end
      end
    end
  end
end
