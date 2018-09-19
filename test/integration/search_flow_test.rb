require 'test_helper'

# Test the get/post actions for the search forms
class SearchTest < ActionDispatch::IntegrationTest
  test 'search basic test with filter sort_by' do
    # Perform a GET search with a search term and sort order in query parameters
    get '/search/notes/one?order=natural&type=natural'
    assert_response :success
    get '/search/notes/one?order=natural&type=boolean'
    assert_response :success
    get '/search/notes/one?order=likes'
    assert_response :success
    get '/search/notes/one?order=views'
    assert_response :success

    # Perform a URL GET search without a term
    get '/search'
    assert_response :success
  end
end
