class SearchController < ApplicationController
  before_action :set_search_criteria

  def new; end

  def notes
    @notes = SearchService.new.find_nodes(params[:query], 15, params[:order_by].to_s.to_sym)
                              .paginate(page: params[:page], per_page: 24)
  end

  def profiles
    @profiles = ExecuteSearch.new.by(:profiles, @search_criteria).paginate(page: params[:page], per_page: 20)
  end

  def questions
    @questions = ExecuteSearch.new.by(:questions, @search_criteria).paginate(page: params[:page], per_page: 20)
  end

  def places
    @nodes = ExecuteSearch.new.by(:places, @search_criteria).paginate(page: params[:page], per_page: 20)
  end

  def tags
    @tags = ExecuteSearch.new.by(:tags, @search_criteria).paginate(page: params[:page], per_page: 20)
  end

  private

  def set_search_criteria
    @search_criteria = SearchCriteria.new(params)
  end

  def search_params
    params.require(:search).permit(:query, :order_by)
  end
end
