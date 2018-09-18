class SearchController < ApplicationController
  before_action :set_search_criteria

  def new; end

  def notes
    @notes = ExecuteSearch.new.by(:notes, @search_criteria).paginate(page: params[:page], per_page: 20)
  end

  def profiles
    @profiles = ExecuteSearch.new.by(:profiles, @search_criteria).paginate(page: params[:page], per_page: 20)
  end

  def questions
    @questions = ExecuteSearch.new.by(:questions, @search_criteria).paginate(page: params[:page], per_page: 20)
  end

  def places
    @places = SearchService.new.textSearch_maps(@search_criteria.query).paginate(page: params[:page], per_page: 20)
  end

  def tags
    @tags = ExecuteSearch.new.by(:tags, @search_criteria).paginate(page: params[:page], per_page: 20)
  end

  private

  def set_search_criteria
    @search_criteria = SearchCriteria.new(params)
  end

  def search_params
    params.require(:search).permit(:query)
  end
end
