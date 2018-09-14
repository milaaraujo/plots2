class SearchController < ApplicationController
  before_action :set_search_criteria

  def new
  end

  def all
    @results = ExecuteSearch.new.by(:all, @search_criteria).values
  end

  def notes
    @notes = ExecuteSearch.new.by(:notes, @search_criteria).paginate(page: params[:page], per_page: 20)
  end

  def profiles
    @profiles = ExecuteSearch.new.by(:profiles, @search_criteria)
  end

  def questions
    @questions = ExecuteSearch.new.by(:questions, @search_criteria)
  end

  def places
    @places = ExecuteSearch.new.by(:taglocations, @search_criteria)
  end

  def tags
    @tags = ExecuteSearch.new.by(:tags, @search_criteria)
  end

  private

  def set_search_criteria
    @search_criteria = SearchCriteria.new(params)
  end
end
