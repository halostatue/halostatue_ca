defmodule HalostatueCa.Component do
  @moduledoc """
  Base component module with shared helpers for templates.
  """

  use Temple.Component

  alias Tableau.Extension.Common

  defmacro __using__(_) do
    quote do
      import Temple
      import unquote(__MODULE__)
    end
  end

  @default_timezone "America/Toronto"

  @doc """
  Format a date or datetime.

  - Date: returns ISO date (2025-11-30)
  - DateTime: returns ISO date + time (2025-11-30 16:42)

  Optional timezone argument overrides the default (America/Toronto).
  """
  def format_date(date, timezone \\ nil)
  def format_date(%Date{} = date, _tz), do: Date.to_iso8601(date)

  def format_date(%DateTime{} = dt, tz) do
    dt
    |> DateTime.shift_zone!(tz || @default_timezone)
    |> Calendar.strftime("%Y-%m-%d %H:%M")
  end

  def format_date(date, tz) when is_binary(date) do
    case Date.from_iso8601(date) do
      {:ok, parsed} -> format_date(parsed, tz)
      _ -> date
    end
  end

  @doc "Render a tag as a link with pagefind filter"
  def tag_link(tag) do
    slug = Common.slugify(tag)

    temple do
      a href: "/tags/#{slug}", data_pagefind_filter: "tag:#{tag}" do
        tag
      end
    end
  end

  @doc "Render tags with separator"
  def tag_links(tags)
  def tag_links([]), do: ""
  def tag_links(nil), do: ""

  def tag_links(tags) when is_list(tags) do
    temple do
      tags
      |> Enum.map(&tag_link/1)
      |> Enum.intersperse(", ")
    end
  end

  @doc "Render an excerpt as markdown HTML"
  def render_excerpt(nil), do: ""
  def render_excerpt(""), do: ""

  def render_excerpt(excerpt) do
    html = Tableau.markdown(excerpt)

    # Extract script tags
    scripts =
      ~r/<script[^>]*>.*?<\/script>/s
      |> Regex.scan(html)
      |> Enum.map(fn [script] -> script end)

    # Store scripts in process dictionary for later injection
    existing = Process.get(:page_scripts, MapSet.new())
    Process.put(:page_scripts, MapSet.union(existing, MapSet.new(scripts)))

    # Remove scripts from excerpt
    String.replace(html, ~r/<script[^>]*>.*?<\/script>/s, "")
  end

  @doc "Get collected scripts for page injection"
  def get_page_scripts do
    :page_scripts
    |> Process.get(MapSet.new())
    |> MapSet.to_list()
    |> Enum.join("\n")
  end

  @doc "Clear collected scripts (call at start of page render)"
  def clear_page_scripts do
    Process.delete(:page_scripts)
  end

  @doc """
  Render post metadata (date, optional tags, optional reading time).

  Options:
  - :show_tags - include tag links (default: false)
  - :show_reading_time - include reading time (default: false), pulled from the :prosody
    frontmatter key
  """
  def post_meta(post, opts \\ []) do
    show_tags = Keyword.get(opts, :show_tags, false)
    show_reading_time = Keyword.get(opts, :show_reading_time, false)

    temple do
      div class: "post-meta" do
        "Published: #{format_date(post.date, post[:timezone])}"

        if post[:revisions] && not Enum.empty?(post.revisions) do
          latest_revision = hd(post.revisions)
          " • Revised: #{format_date(latest_revision.date, nil)}"
        end

        if show_reading_time && post[:prosody] do
          " • #{post.prosody.reading_time} min read"
        end

        if show_tags && post[:tags] && not Enum.empty?(post.tags) do
          " • Tagged: "
          tag_links(post.tags)
        end
      end
    end
  end

  @doc """
  Render post header metadata for layouts (published, updated, reading time, tags).
  """
  def post_header_meta(page) do
    temple do
      div class: "post-meta", data_pagefind_ignore: true do
        "Published: "

        time datetime: format_date(page.date, page[:timezone]) do
          format_date(page.date, page[:timezone])
        end

        if page[:revisions] && not Enum.empty?(page.revisions) do
          latest_revision = hd(page.revisions)

          " • Revised: "

          a href: "#revisions" do
            time datetime: format_date(latest_revision.date, nil) do
              format_date(latest_revision.date, nil)
            end
          end
        end

        if page[:reading_time] do
          " • #{page.reading_time} min read"
        end

        if page[:tags] && not Enum.empty?(page.tags) do
          " • Tagged: "
          tag_links(page.tags)
        end
      end
    end
  end

  @doc """
  Render a single post list item with title, meta, and optional excerpt.

  Options:
  - :show_tags - include tag links in meta (default: true)
  - :show_excerpt - include excerpt if present (default: true)
  """
  def post_list_item(post, opts \\ []) do
    show_tags = Keyword.get(opts, :show_tags, true)
    show_excerpt = Keyword.get(opts, :show_excerpt, true)

    temple do
      li class: "post-list-item" do
        h3 class: "post-list-title" do
          a href: post.permalink do
            post.title
          end
        end

        post_meta(post, show_tags: show_tags)

        if show_excerpt && post[:excerpt] do
          div class: "post-list-excerpt" do
            render_excerpt(post.excerpt)
          end
        end
      end
    end
  end

  @doc """
  Render a list of posts.

  Options:
  - :show_tags - include tag links (default: true)
  - :show_excerpt - include excerpts (default: true)
  - :empty_message - message when no posts (default: "No posts yet. Check back soon!")
  """
  def post_list(posts, opts \\ []) do
    empty_message = Keyword.get(opts, :empty_message, "No posts yet. Check back soon!")
    item_opts = Keyword.take(opts, [:show_tags, :show_excerpt])

    temple do
      if Enum.empty?(posts) do
        p class: "text-muted" do
          empty_message
        end
      else
        ul class: "post-list", id: "post-list" do
          for post <- posts do
            post_list_item(post, item_opts)
          end
        end
      end
    end
  end

  @doc "Get posts from site pages, sorted by date descending"
  def get_posts(site, opts \\ []) do
    limit = Keyword.get(opts, :limit)

    posts =
      site.pages
      |> Enum.filter(& &1[:__tableau_post_extension__])
      |> Enum.sort_by(& &1.date, {:desc, Date})

    if limit, do: Enum.take(posts, limit), else: posts
  end
end
