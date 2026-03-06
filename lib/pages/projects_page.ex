defmodule HalostatueCa.ProjectsPage do
  @moduledoc """
  Page that lists all projects.
  """
  use HalostatueCa.Component

  use Tableau.Page,
    layout: HalostatueCa.RootLayout,
    permalink: "/projects",
    title: "Projects"

  def template(assigns) do
    projects = Enum.filter(assigns.site.pages, &(&1[:layout] == HalostatueCa.ProjectLayout))

    grouped_projects =
      projects
      |> Enum.group_by(fn project ->
        case project[:categories] do
          [primary | _] -> primary
          _ -> "Uncategorized"
        end
      end)
      |> Enum.map(fn {category, category_projects} ->
        {category, Enum.sort_by(category_projects, & &1.title)}
      end)
      |> Enum.sort_by(fn {category, _} -> category end)

    temple do
      section do
        h2 do
          "Projects"
        end

        for {category, category_projects} <- grouped_projects do
          div class: "project-category" do
            h3 do
              category
            end

            ul class: "project-list" do
              for project <- category_projects do
                li class: "project-list-item" do
                  a href: project.permalink, class: "project-link" do
                    project.title
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
