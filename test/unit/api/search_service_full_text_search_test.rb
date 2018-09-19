require 'test_helper'
require "minitest/autorun"

class SearchServiceFullTextSearchTest < ActiveSupport::TestCase

  def running_profiles_by_username_and_bio
    skip "full text search only works on mysql/mariadb" if ActiveRecord::Base.connection.adapter_name == 'sqlite3'

    users = [users(:data), users(:steff3), users(:steff2), users(:steff1)]

    params = { srchString: 'steff' }
    search_criteria = SearchCriteria.from_params(params)

    result = SearchService.new.profiles(search_criteria)

    assert_not_nil result
    assert_equal assert_equal result.size, 4
  end

  test 'running profiles by username and bio' do
    # User.search() only works for mysql/mariadb
    if ActiveRecord::Base.connection.adapter_name == 'sqlite3'
      users = [users(:data), users(:steff3), users(:steff2), users(:steff1)]

      params = { srchString: 'steff' }
      search_criteria = SearchCriteria.from_params(params)

      result = SearchService.new.profiles(search_criteria)

      assert_not_nil result
      assert_equal assert_equal result.size, 4
    end
  end
end
