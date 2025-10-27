defmodule HalostatueCa.PostLayout do
  @moduledoc false

  use HalostatueCa.Component
  use Tableau.Layout, layout: HalostatueCa.RootLayout

  def template(assigns) do
    page = assigns.page

    temple do
      article class: "post", data_pagefind_body: true, data_pagefind_filter: "type:post" do
        header class: "post-header" do
          h1 class: "post-title" do
            page.title
          end

          post_header_meta(page)
        end

        div class: "post-content" do
          render(@inner_content)
        end

        post_revisions(page)
      end
    end
  end

  defp post_revisions(%{revisions: revisions}) when is_list(revisions) and revisions != [] do
    temple do
      aside id: "revisions", class: "post-revisions", data_pagefind_ignore: true do
        h3 do
          "Revisions"
        end

        dl do
          for revision <- Enum.reverse(revisions) do
            dt do
              format_date(revision.date, nil)
            end

            dd do
              Tableau.markdown(revision.rev)
            end
          end
        end
      end
    end
  end

  defp post_revisions(_page), do: nil
end
