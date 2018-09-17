module SearchHelper
  def create_nav_links(active_page, query)
    links = [
      { section: "search-all", text: "All", path: "/search/#{query}/all" },
      { section: "search-notes", text: "Notes", path: "/search/#{query}/notes" },
      { section: "search-profiles", text: "Profiles", path: "/search/#{query}/profiles" },
      { section: "search-tags", text: "Tags", path: "/search/#{query}/tags" },
      { section: "search-questions", text: "Questions", path: "/search/#{query}/questions" },
      { section: "search-places", text: "Places", path: "/search/#{query}/places" }
    ]

    result = ""
    links.each do |link|
      active_link =
        if active_page == link[:section]
          "list-group-item list-group-item-action active"
        else
          "list-group-item list-group-item-action"
        end
      result += " <li><a href='#{link[:path]}' class='#{active_link}'>#{link[:text]}</a> </li>"
    end
    result.html_safe
  end
end
