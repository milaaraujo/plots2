class ExecuteSearch
  def by(type, search_criteria)
    execute(type, search_criteria)
  end

  private

  def execute(type, search_criteria)
    sservice = SearchService.new
    case type
     when :all
       return sservice.textSearch_all(search_criteria)
     when :profiles
       return sservice.profiles(search_criteria)
     when :notes
       return sservice.textSearch_notes(search_criteria.query)
     when :questions
       return sservice.textSearch_questions(search_criteria.query)
     when :tags
       return sservice.textSearch_tags(search_criteria.query)
     when :peoplelocations
       return sservice.people_locations(search_criteria.query, search_criteria.tag)
     when :taglocations
       return sservice.tagNearbyNodes(search_criteria.query, search_criteria.tag)
     else
       return []
     end
  end
end
